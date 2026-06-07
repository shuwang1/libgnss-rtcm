/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Status codes returned by the RTCM decoder.
public enum RTCMStatus: Int {
    case error = -1
    case noMessage = 0
    case observation = 1
    case ephemeris = 2
    case station = 5
    case ssr = 10
}

/// A decoder for RTCM ver.3 data streams.
public final class RTCM3Decoder: @unchecked Sendable {
    
    private let contextLock = NSLock()
    private var _context = RTCMContext()
    
    /// The current decoding context.
    public var context: RTCMContext {
        contextLock.lock()
        defer { contextLock.unlock() }
        return _context
    }
    
    public init() {}
    
    /// Processes a single byte from the stream.
    /// - Parameter data: The byte to process.
    /// - Returns: The status of the decoding process.
    public func inputByte(_ data: UInt8) -> RTCMStatus {
        contextLock.lock()
        defer { contextLock.unlock() }
        
        // Synchronize frame
        if _context.nbyte == 0 {
            if data != 0xD3 { return .noMessage }
            _context.buff[0] = data
            _context.nbyte = 1
            return .noMessage
        }
        
        if _context.nbyte < _context.buff.count {
            _context.buff[_context.nbyte] = data
            _context.nbyte += 1
        } else {
            // Buffer overflow, reset
            _context.nbyte = 0
            return .noMessage
        }
        
        if _context.nbyte == 3 {
            // Read length (10 bits starting from bit 14)
            let length = BitUtilities.getbitu(_context.buff, pos: 14, len: 10)
            _context.len = Int(length) + 3 // length without parity
        }
        
        if _context.nbyte < 3 || _context.nbyte < _context.len + 3 {
            return .noMessage
        }
        
        // Full frame received
        let frameLen = _context.len
        _context.nbyte = 0 // Reset for next frame
        
        // Check CRC
        let providedCrc = BitUtilities.getbitu(_context.buff, pos: frameLen * 8, len: 24)
        let calculatedCrc = CRC.crc24q(_context.buff.prefix(frameLen))
        
        if providedCrc != calculatedCrc {
            // Parity error
            return .noMessage
        }
        
        // Decode message
        return decodeRTCM3()
    }
    
    private func decodeRTCM3() -> RTCMStatus {
        let payload = _context.buff.prefix(_context.len).dropFirst(3)
        let reader = BitReader(data: Data(payload))
        
        guard let messageType = reader.readInt(bits: 12) else { return .error }
        _context.outtype = messageType
        
        // Increment message count
        if messageType >= 1001 && messageType <= 1299 {
            _context.nmsg3[messageType - 1000] += 1
        }
        
        // Dispatch to specific decoders
        switch messageType {
        case 1005:
            return decodeType1005_1006(reader: reader, is1006: false)
        case 1006:
            return decodeType1005_1006(reader: reader, is1006: true)
        case 1019:
            return decodeType1019(reader: reader)
        default:
            return .noMessage
        }
    }
    
    // Implementation for message decoders
    private func decodeType1005_1006(reader: BitReader, is1006: Bool) -> RTCMStatus {
        _ = reader.position
        _ = _context.len * 8
        _ = is1006 ? 156 : 140
        
        // Note: bit counts are relative to the start of the payload
        // Message Type (12 bits) is already read.
        
        let staid = reader.readInt(bits: 12) ?? 0
        let itrf = reader.readInt(bits: 6) ?? 0
        reader.skip(bits: 4) // Reserved
        
        let rr0 = Double(reader.readInt64(bits: 38) ?? 0)
        reader.skip(bits: 2)
        let rr1 = Double(reader.readInt64(bits: 38) ?? 0)
        reader.skip(bits: 2)
        let rr2 = Double(reader.readInt64(bits: 38) ?? 0)
        
        _context.staid = staid
        _context.sta.itrf = itrf
        _context.sta.deltype = is1006 ? 1 : 0
        _context.sta.pos = [rr0 * 0.0001, rr1 * 0.0001, rr2 * 0.0001]
        
        if is1006 {
            let anth = Double(reader.readInt(bits: 16) ?? 0)
            _context.sta.hgt = anth * 0.0001
        } else {
            _context.sta.hgt = 0.0
        }
        
        return .station
    }

    private func decodeType1019(reader: BitReader) -> RTCMStatus {
        _ = reader.position
        _ = _context.len * 8
        
        // Required bits for 1019 is ~476
        
        var prn = reader.readInt(bits: 6) ?? 0
        let week = reader.readInt(bits: 10) ?? 0
        
        var eph = Ephemeris()
        eph.sva = reader.readInt(bits: 4) ?? 0
        eph.code = reader.readInt(bits: 2) ?? 0
        
        let p2_43 = pow(2.0, -43.0)
        let p2_55 = pow(2.0, -55.0)
        let p2_31 = pow(2.0, -31.0)
        let p2_5 = pow(2.0, -5.0)
        let p2_29 = pow(2.0, -29.0)
        let p2_33 = pow(2.0, -33.0)
        let p2_19 = pow(2.0, -19.0)
        let sc2rad = GNSSConstants.SC2RAD
        
        eph.idot = Double(reader.readInt64(bits: 14) ?? 0) * p2_43 * sc2rad
        eph.iode = reader.readInt(bits: 8) ?? 0
        let toc = Double(reader.readInt(bits: 16) ?? 0) * 16.0
        eph.f2 = Double(reader.readInt64(bits: 8) ?? 0) * p2_55
        eph.f1 = Double(reader.readInt64(bits: 16) ?? 0) * p2_43
        eph.f0 = Double(reader.readInt64(bits: 22) ?? 0) * p2_31
        eph.iodc = reader.readInt(bits: 10) ?? 0
        eph.crs = Double(reader.readInt64(bits: 16) ?? 0) * p2_5
        eph.deln = Double(reader.readInt64(bits: 16) ?? 0) * p2_43 * sc2rad
        eph.M0 = Double(reader.readInt64(bits: 32) ?? 0) * p2_31 * sc2rad
        eph.cuc = Double(reader.readInt64(bits: 16) ?? 0) * p2_29
        eph.e = Double(reader.readInt(bits: 32) ?? 0) * p2_33
        eph.cus = Double(reader.readInt64(bits: 16) ?? 0) * p2_29
        let sqrtA = Double(reader.readInt(bits: 32) ?? 0) * p2_19
        eph.A = sqrtA * sqrtA
        eph.toes = Double(reader.readInt(bits: 16) ?? 0) * 16.0
        eph.cic = Double(reader.readInt64(bits: 16) ?? 0) * p2_29
        eph.OMG0 = Double(reader.readInt64(bits: 32) ?? 0) * p2_31 * sc2rad
        eph.cis = Double(reader.readInt64(bits: 16) ?? 0) * p2_29
        eph.i0 = Double(reader.readInt64(bits: 32) ?? 0) * p2_31 * sc2rad
        eph.crc = Double(reader.readInt64(bits: 16) ?? 0) * p2_5
        eph.omg = Double(reader.readInt64(bits: 32) ?? 0) * p2_31 * sc2rad
        eph.OMGd = Double(reader.readInt64(bits: 24) ?? 0) * p2_43 * sc2rad
        eph.tgd[0] = Double(reader.readInt64(bits: 8) ?? 0) * p2_31
        eph.svh = reader.readInt(bits: 6) ?? 0
        eph.flag = reader.readInt(bits: 1) ?? 0
        eph.fit = (reader.readInt(bits: 1) ?? 0) != 0 ? 0.0 : 4.0
        
        var system = GNSSSystem.gps
        if prn >= 40 {
            system = .sbs
            prn += 80
        }
        
        let sat = SatelliteUtilities.satNo(system: system, prn: prn)
        if sat == 0 { return .error }
        
        eph.sat = sat
        eph.week = week
        eph.toe = TimeUtilities.gpstToTime(week: eph.week, tow: eph.toes)
        eph.toc = TimeUtilities.gpstToTime(week: eph.week, tow: toc)
        eph.ttr = _context.time
        
        _context.ephSat = sat
        _context.nav.eph.append(eph)
        
        return .ephemeris
    }
}

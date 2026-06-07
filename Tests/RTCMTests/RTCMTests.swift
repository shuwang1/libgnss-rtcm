/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import XCTest
import Foundation
@testable import RTCM

final class RTCMTests: XCTestCase {
    
    // MARK: - BitUtilities Tests
    
    func testGetBitu() {
        let data = Data([0b10101010, 0b11001100])
        XCTAssertEqual(BitUtilities.getbitu(data, pos: 0, len: 4), 10)
        XCTAssertEqual(BitUtilities.getbitu(data, pos: 4, len: 4), 10)
        XCTAssertEqual(BitUtilities.getbitu(data, pos: 8, len: 4), 12)
    }
    
    func testGetBits() {
        let data = Data([0b11111111])
        XCTAssertEqual(BitUtilities.getbits(data, pos: 0, len: 4), -1)
        XCTAssertEqual(BitUtilities.getbits(data, pos: 0, len: 8), -1)
    }
    
    func testBitReader() {
        let data = Data([0xD3, 0x00, 0x13])
        let reader = BitReader(data: data)
        XCTAssertEqual(reader.readInt(bits: 8), 0xD3)
        XCTAssertEqual(reader.readInt(bits: 6), 0)
        XCTAssertEqual(reader.readInt(bits: 10), 19)
    }
    
    // MARK: - CRC Tests
    
    func testCRC24Q() {
        let data = Data([0xD3, 0x00, 0x13, 0x3E, 0x3D, 0xFE])
        let crc1 = CRC.crc24q(data)
        let crc2 = CRC.crc24qBitwise(data)
        XCTAssertEqual(crc1, crc2)
    }
    
    // MARK: - GNSSTime Tests
    
    func testEpochToTime() {
        let t = TimeUtilities.epochToTime(year: 1980, month: 1, day: 6)
        XCTAssertEqual(t.time, 315964800)
        XCTAssertEqual(t.sec, 0.0)
    }
    
    func testTimeToGPST() {
        let t = TimeUtilities.epochToTime(year: 1980, month: 1, day: 6, hour: 0, min: 0, sec: 1.5)
        let gpst = TimeUtilities.timeToGPST(t)
        XCTAssertEqual(gpst.week, 0)
        XCTAssertEqual(gpst.tow, 1.5)
    }
    
    // MARK: - RTCM3 Decoder Tests
    
    func testDecode1005() {
        let decoder = RTCM3Decoder()
        // Type 1005 (0x3ED), StaID 1, ITRF 0, All pos 0
        // Payload (19 bytes):
        // Bits: [1005: 12][StaID: 12][ITRF: 6][Reserved: 4][X: 38][Res: 2][Y: 38][Res: 2][Z: 38]
        // Total payload bits: 152 bits (19 bytes)
        
        var payload = Data(count: 19)
        // Set type 1005 (bits 0-11): 0011 1110 1101 -> 0x3ED
        // StaID 1 (bits 12-23): 0000 0000 0001 -> 0x001
        
        // Manual bit packing for the test
        // Byte 0: 00111110 (0x3E)
        // Byte 1: 11010000 (0xD0) - Lower 4 bits of 1005 (1101) + Upper 4 bits of StaID (0000)
        // Byte 2: 00000001 (0x01) - Remaining 8 bits of StaID (00000001)
        // Byte 3: 00000000 (0x00) - ITRF(6) + Res(2)
        // Rest zeros for coordinates
        
        payload[0] = 0x3E
        payload[1] = 0xD0
        payload[2] = 0x01
        payload[3] = 0x00
        
        let header: [UInt8] = [0xD3, 0x00, 0x13]
        let frameWithoutCrc = Data(header + payload)
        let crc = CRC.crc24q(frameWithoutCrc)
        
        let fullFrame = frameWithoutCrc + Data([
            UInt8((crc >> 16) & 0xFF),
            UInt8((crc >> 8) & 0xFF),
            UInt8(crc & 0xFF)
        ])
        
        var status: RTCMStatus = .noMessage
        for byte in fullFrame {
            status = decoder.inputByte(byte)
            if status != .noMessage { break }
        }
        
        XCTAssertEqual(status, .station)
        XCTAssertEqual(decoder.context.staid, 1)
        XCTAssertEqual(decoder.context.sta.pos, [0.0, 0.0, 0.0])
    }
}

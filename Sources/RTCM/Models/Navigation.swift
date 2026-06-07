/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// SSR (State Space Representation) correction type.
/// Mimics `ssr_t`.
public struct SSR: Sendable {
    /// Epoch time (GPST) {eph, clk, hrclk, ura, bias}.
    public var t0: [GNSSTime]
    /// SSR update interval (s).
    public var udi: [Double]
    /// IOD SSR {eph, clk, hrclk, ura, bias}.
    public var iod: [Int]
    /// Issue of data.
    public var iode: Int
    /// Issue of data CRC for BeiDou/SBAS.
    public var iodcrc: Int
    /// URA indicator.
    public var ura: Int
    /// Sat ref datum (0:ITRF, 1:regional).
    public var refd: Int
    
    /// Delta orbit {radial, along, cross} (m).
    public var deph: [Double]
    /// Dot delta orbit {radial, along, cross} (m/s).
    public var ddeph: [Double]
    /// Delta clock {c0, c1, c2} (m, m/s, m/s^2).
    public var dclk: [Double]
    /// High-rate clock correction (m).
    public var hrclk: Double
    /// Code biases (m).
    public var cbias: [Float]
    /// Update flag (0:no update, 1:update).
    public var update: UInt8
    
    public init() {
        self.t0 = Array(repeating: GNSSTime(), count: 5)
        self.udi = Array(repeating: 0.0, count: 5)
        self.iod = Array(repeating: 0, count: 5)
        self.iode = 0
        self.iodcrc = 0
        self.ura = 0
        self.refd = 0
        self.deph = [0.0, 0.0, 0.0]
        self.ddeph = [0.0, 0.0, 0.0]
        self.dclk = [0.0, 0.0, 0.0]
        self.hrclk = 0.0
        self.cbias = Array(repeating: 0.0, count: GNSSObservationCode.maxcode_value)
        self.update = 0
    }
}

extension GNSSObservationCode {
    static let maxcode_value = 48
}

/// Navigation data type.
/// Mimics `nav_t`.
public struct Navigation: Sendable {
    /// GPS/QZS/GAL ephemeris.
    public var eph: [Ephemeris]
    /// GLONASS ephemeris.
    public var geph: [GLONASSEphemeris]
    
    // In a full implementation, we would include SBAS, precise ephemeris, etc.
    // For this phased port, we focus on the core broadcase ephemeris.
    
    /// Leap seconds (s).
    public var leaps: Int
    
    /// SSR corrections.
    public var ssr: [SSR]
    
    public init() {
        self.eph = []
        self.geph = []
        self.leaps = 0
        self.ssr = Array(repeating: SSR(), count: GNSSLimits.maxSat + 1)
    }
}

/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// GLONASS broadcast ephemeris type.
/// Mimics `geph_t`.
public struct GLONASSEphemeris: Sendable {
    /// Satellite number.
    public var sat: Int
    /// IODE (0-6 bit of tb field).
    public var iode: Int
    /// Satellite frequency number.
    public var frq: Int
    /// Satellite health, accuracy, age of operation.
    public var svh: Int
    public var sva: Int
    public var age: Int
    
    /// Epoch of ephemerides (GPST).
    public var toe: GNSSTime
    /// Message frame time (GPST).
    public var tof: GNSSTime
    
    /// Satellite position (ECEF) (m).
    public var pos: [Double]
    /// Satellite velocity (ECEF) (m/s).
    public var vel: [Double]
    /// Satellite acceleration (ECEF) (m/s^2).
    public var acc: [Double]
    
    /// SV clock bias (s) / relative freq bias.
    public var taun: Double
    public var gamn: Double
    /// Delay between L1 and L2 (s).
    public var dtaun: Double
    
    public init(sat: Int = 0) {
        self.sat = sat
        self.iode = 0
        self.frq = 0
        self.svh = 0
        self.sva = 0
        self.age = 0
        self.toe = GNSSTime()
        self.tof = GNSSTime()
        self.pos = [0.0, 0.0, 0.0]
        self.vel = [0.0, 0.0, 0.0]
        self.acc = [0.0, 0.0, 0.0]
        self.taun = 0.0
        self.gamn = 0.0
        self.dtaun = 0.0
    }
}

/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Global constants for GNSS calculations.
public enum GNSSConstants {
    /// Speed of light (m/s).
    public static let CLIGHT = 299792458.0
    /// Semi-circle to radian (IS-GPS).
    public static let SC2RAD = 3.1415926535898
    /// 1 AU (m).
    public static let AU = 149597870691.0
}

/// Navigation systems supported by the library.
public struct GNSSSystem: OptionSet, Sendable {
    public let rawValue: UInt8
    public init(rawValue: UInt8) { self.rawValue = rawValue }
    
    public static let none: GNSSSystem = []
    public static let gps  = GNSSSystem(rawValue: 0x01)
    public static let sbs  = GNSSSystem(rawValue: 0x02)
    public static let glo  = GNSSSystem(rawValue: 0x04)
    public static let gal  = GNSSSystem(rawValue: 0x08)
    public static let qzs  = GNSSSystem(rawValue: 0x10)
    public static let bds  = GNSSSystem(rawValue: 0x20)
    public static let leo  = GNSSSystem(rawValue: 0x80)
    public static let all  = GNSSSystem(rawValue: 0xFF)
}

/// Time systems used in GNSS.
public enum GNSSTimeSystem: Int, Sendable {
    case gps = 0
    case utc = 1
    case gal = 3
    case qzs = 4
    case bds = 5
}

/// Observation codes (Signal types).
public enum GNSSObservationCode: UInt8, Sendable {
    case none = 0
    case l1c = 1
    case l1p = 2
    case l1w = 3
    case l1y = 4
    case l1m = 5
    case l1n = 6
    case l1s = 7
    case l1l = 8
    case l1a = 10
    case l1b = 11
    case l1x = 12
    case l1z = 13
    case l2c = 14
    case l2d = 15
    case l2s = 16
    case l2l = 17
    case l2x = 18
    case l2p = 19
    case l2w = 20
    case l2y = 21
    case l2m = 22
    case l2n = 23
    case l5i = 24
    case l5q = 25
    case l5x = 26
    case l7i = 27
    case l7q = 28
    case l7x = 29
    case l6a = 30
    case l6b = 31
    case l6c = 32
    case l6x = 33
    case l6z = 34
    case l6s = 35
    case l6l = 36
    case l8i = 37
    case l8q = 38
    case l8x = 39
    case l6i = 42
    case l6q = 43
    case l1i = 47
    case l1q = 48
}

/// Limits and configuration for GNSS data structures.
public enum GNSSLimits {
    public static let maxFreq = 7
    public static let nFreq = 3
    public static let nExObs = 0
    
    public static let maxSatGPS = 32
    public static let maxSatGLO = 24
    public static let maxSatGAL = 30
    public static let maxSatQZS = 7
    public static let maxSatBDS = 35
    public static let maxSatSBS = 23
    public static let maxSatLEO = 10
    
    public static let maxSat = 161 // Total of all maxSatXXX above
    
    public static let maxObs = 64
}

/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Utilities for satellite numbering and system identification.
public enum SatelliteUtilities {
    
    /// Minimum and maximum PRN/slot numbers for each system.
    private enum Limits {
        static let minPRNGPS = 1
        static let maxPRNGPS = 32
        static let nsGPS = 32
        
        static let minPRNGLO = 1
        static let maxPRNGLO = 24
        static let nsGLO = 24
        
        static let minPRNGAL = 1
        static let maxPRNGAL = 30
        static let nsGAL = 30
        
        static let minPRNQZS = 193
        static let maxPRNQZS = 199
        static let nsQZS = 7
        
        static let minPRNCMP = 1
        static let maxPRNCMP = 35
        static let nsCMP = 35
        
        static let minPRNLEO = 1
        static let maxPRNLEO = 10
        static let nsLEO = 10
        
        static let minPRNSBS = 120
        static let maxPRNSBS = 142
        static let nsSBS = 23
    }
    
    /// Converts satellite system and PRN/slot number to a global satellite number (1-MAXSAT).
    /// - Parameters:
    ///   - system: The navigation system.
    ///   - prn: The PRN or slot number.
    /// - Returns: The global satellite number, or 0 if invalid.
    public static func satNo(system: GNSSSystem, prn: Int) -> Int {
        if prn <= 0 { return 0 }
        switch system {
        case .gps:
            if prn < Limits.minPRNGPS || prn > Limits.maxPRNGPS { return 0 }
            return prn - Limits.minPRNGPS + 1
        case .glo:
            if prn < Limits.minPRNGLO || prn > Limits.maxPRNGLO { return 0 }
            return Limits.nsGPS + prn - Limits.minPRNGLO + 1
        case .gal:
            if prn < Limits.minPRNGAL || prn > Limits.maxPRNGAL { return 0 }
            return Limits.nsGPS + Limits.nsGLO + prn - Limits.minPRNGAL + 1
        case .qzs:
            if prn < Limits.minPRNQZS || prn > Limits.maxPRNQZS { return 0 }
            return Limits.nsGPS + Limits.nsGLO + Limits.nsGAL + prn - Limits.minPRNQZS + 1
        case .bds:
            if prn < Limits.minPRNCMP || prn > Limits.maxPRNCMP { return 0 }
            return Limits.nsGPS + Limits.nsGLO + Limits.nsGAL + Limits.nsQZS + prn - Limits.minPRNCMP + 1
        case .leo:
            if prn < Limits.minPRNLEO || prn > Limits.maxPRNLEO { return 0 }
            return Limits.nsGPS + Limits.nsGLO + Limits.nsGAL + Limits.nsQZS + Limits.nsCMP + prn - Limits.minPRNLEO + 1
        case .sbs:
            if prn < Limits.minPRNSBS || prn > Limits.maxPRNSBS { return 0 }
            return Limits.nsGPS + Limits.nsGLO + Limits.nsGAL + Limits.nsQZS + Limits.nsCMP + Limits.nsLEO + prn - Limits.minPRNSBS + 1
        default:
            return 0
        }
    }
    
    /// Converts a global satellite number (1-MAXSAT) to its system and PRN/slot number.
    /// - Parameter sat: The global satellite number.
    /// - Returns: A tuple containing the system and PRN, or (.none, 0) if invalid.
    public static func satSystem(sat: Int) -> (system: GNSSSystem, prn: Int) {
        var s = sat
        if s <= 0 || s > GNSSLimits.maxSat { return (.none, 0) }
        
        if s <= Limits.nsGPS {
            return (.gps, s + Limits.minPRNGPS - 1)
        }
        s -= Limits.nsGPS
        if s <= Limits.nsGLO {
            return (.glo, s + Limits.minPRNGLO - 1)
        }
        s -= Limits.nsGLO
        if s <= Limits.nsGAL {
            return (.gal, s + Limits.minPRNGAL - 1)
        }
        s -= Limits.nsGAL
        if s <= Limits.nsQZS {
            return (.qzs, s + Limits.minPRNQZS - 1)
        }
        s -= Limits.nsQZS
        if s <= Limits.nsCMP {
            return (.bds, s + Limits.minPRNCMP - 1)
        }
        s -= Limits.nsCMP
        if s <= Limits.nsLEO {
            return (.leo, s + Limits.minPRNLEO - 1)
        }
        s -= Limits.nsLEO
        if s <= Limits.nsSBS {
            return (.sbs, s + Limits.minPRNSBS - 1)
        }
        
        return (.none, 0)
    }
}

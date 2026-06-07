/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Mathematical utilities for GNSS calculations.
public enum GNSSMath {
    
    /// Earth's semi-major axis (WGS84) (m).
    public static let WGS84_A = 6378137.0
    /// Earth's flattening (WGS84).
    public static let WGS84_F = 1.0 / 298.257223563
    
    /// Computes the magnitude of a 3D vector.
    public static func norm(_ v: [Double]) -> Double {
        guard v.count >= 3 else { return 0.0 }
        return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
    }
    
    /// Computes the dot product of two 3D vectors.
    public static func dot(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count >= 3, b.count >= 3 else { return 0.0 }
        return a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
    }
    
    /// Computes the cross product of two 3D vectors.
    public static func cross(_ a: [Double], _ b: [Double]) -> [Double] {
        guard a.count >= 3, b.count >= 3 else { return [0, 0, 0] }
        return [
            a[1]*b[2] - a[2]*b[1],
            a[2]*b[0] - a[0]*b[2],
            a[0]*b[1] - a[1]*b[0]
        ]
    }
    
    /// Converts ECEF coordinates to geodetic coordinates (lat, lon, h).
    /// - Parameter ecef: [x, y, z] in meters.
    /// - Returns: [lat, lon, h] in radians and meters.
    public static func ecef2pos(_ ecef: [Double]) -> [Double] {
        guard ecef.count >= 3 else { return [0, 0, 0] }
        let a = WGS84_A
        let f = WGS84_F
        let e2 = f * (2 - f)
        let r2 = ecef[0]*ecef[0] + ecef[1]*ecef[1]
        var z = ecef[2]
        var zk = 0.0
        var v = a
        var sinP = 0.0
        
        while abs(z - zk) >= 1E-4 {
            zk = z
            sinP = z / sqrt(r2 + z*z)
            v = a / sqrt(1.0 - e2 * sinP * sinP)
            z = ecef[2] + v * e2 * sinP
        }
        
        let lon = r2 > 1E-12 ? atan2(ecef[1], ecef[0]) : 0.0
        let lat = r2 > 1E-12 ? atan2(z, sqrt(r2)) : (ecef[2] > 0 ? Double.pi/2 : -Double.pi/2)
        let h = sqrt(r2 + z*z) - v
        
        return [lat, lon, h]
    }
    
    /// Converts geodetic coordinates (lat, lon, h) to ECEF coordinates.
    /// - Parameter pos: [lat, lon, h] in radians and meters.
    /// - Returns: [x, y, z] in meters.
    public static func pos2ecef(_ pos: [Double]) -> [Double] {
        guard pos.count >= 3 else { return [0, 0, 0] }
        let a = WGS84_A
        let f = WGS84_F
        let e2 = f * (2 - f)
        let sinP = sin(pos[0])
        let cosP = cos(pos[0])
        let sinL = sin(pos[1])
        let cosL = cos(pos[1])
        let v = a / sqrt(1.0 - e2 * sinP * sinP)
        
        return [
            (v + pos[2]) * cosP * cosL,
            (v + pos[2]) * cosP * sinL,
            (v * (1.0 - e2) + pos[2]) * sinP
        ]
    }
}

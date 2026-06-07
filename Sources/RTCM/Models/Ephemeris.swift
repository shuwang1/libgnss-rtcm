/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// GPS/QZS/GAL broadcast ephemeris type.
/// Mimics `eph_t`.
public struct Ephemeris: Sendable {
    /// Satellite number.
    public var sat: Int
    /// IODE, IODC.
    public var iode: Int
    public var iodc: Int
    /// SV accuracy (URA index).
    public var sva: Int
    /// SV health (0:ok).
    public var svh: Int
    /// GPS/QZS: gps week, GAL: galileo week.
    public var week: Int
    /// GPS/QZS: code on L2, GAL/CMP: data sources.
    public var code: Int
    /// GPS/QZS: L2 P data flag, CMP: nav type.
    public var flag: Int
    
    /// Toe, Toc, T_trans.
    public var toe: GNSSTime
    public var toc: GNSSTime
    public var ttr: GNSSTime
    
    /// SV orbit parameters.
    public var A: Double
    public var e: Double
    public var i0: Double
    public var OMG0: Double
    public var omg: Double
    public var M0: Double
    public var deln: Double
    public var OMGd: Double
    public var idot: Double
    
    public var crc: Double
    public var crs: Double
    public var cuc: Double
    public var cus: Double
    public var cic: Double
    public var cis: Double
    
    /// Toe (s) in week.
    public var toes: Double
    /// Fit interval (h).
    public var fit: Double
    /// SV clock parameters (af0, af1, af2).
    public var f0: Double
    public var f1: Double
    public var f2: Double
    
    /// Group delay parameters.
    /// GPS/QZS: tgd[0]=TGD
    /// GAL: tgd[0]=BGD E5a/E1, tgd[1]=BGD E5b/E1
    /// CMP: tgd[0]=BGD1, tgd[1]=BGD2
    public var tgd: [Double]
    
    /// Adot, ndot for CNAV.
    public var Adot: Double
    public var ndot: Double
    
    public init(sat: Int = 0) {
        self.sat = sat
        self.iode = 0
        self.iodc = 0
        self.sva = 0
        self.svh = 0
        self.week = 0
        self.code = 0
        self.flag = 0
        self.toe = GNSSTime()
        self.toc = GNSSTime()
        self.ttr = GNSSTime()
        self.A = 0.0
        self.e = 0.0
        self.i0 = 0.0
        self.OMG0 = 0.0
        self.omg = 0.0
        self.M0 = 0.0
        self.deln = 0.0
        self.OMGd = 0.0
        self.idot = 0.0
        self.crc = 0.0
        self.crs = 0.0
        self.cuc = 0.0
        self.cus = 0.0
        self.cic = 0.0
        self.cis = 0.0
        self.toes = 0.0
        self.fit = 0.0
        self.f0 = 0.0
        self.f1 = 0.0
        self.f2 = 0.0
        self.tgd = [0.0, 0.0, 0.0, 0.0]
        self.Adot = 0.0
        self.ndot = 0.0
    }
}

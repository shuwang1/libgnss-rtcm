/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Station parameter type.
/// Mimics `sta_t`.
public struct Station: Sendable {
    /// Marker name.
    public var name: String
    /// Marker number.
    public var marker: String
    /// Antenna descriptor.
    public var antdes: String
    /// Antenna serial number.
    public var antsno: String
    /// Receiver type descriptor.
    public var rectype: String
    /// Receiver firmware version.
    public var recver: String
    /// Receiver serial number.
    public var recsno: String
    
    /// Antenna setup ID.
    public var antsetup: Int
    /// ITRF realization year.
    public var itrf: Int
    /// Antenna delta type (0:enu, 1:xyz).
    public var deltype: Int
    
    /// Station position (ECEF) (m).
    public var pos: [Double]
    /// Antenna position delta (e/n/u or x/y/z) (m).
    public var del: [Double]
    /// Antenna height (m).
    public var hgt: Double
    
    public init() {
        self.name = ""
        self.marker = ""
        self.antdes = ""
        self.antsno = ""
        self.rectype = ""
        self.recver = ""
        self.recsno = ""
        self.antsetup = 0
        self.itrf = 0
        self.deltype = 0
        self.pos = [0.0, 0.0, 0.0]
        self.del = [0.0, 0.0, 0.0]
        self.hgt = 0.0
    }
}

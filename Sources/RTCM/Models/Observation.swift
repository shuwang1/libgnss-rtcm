/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Observation data record for a single satellite at a single epoch.
/// Mimics `obsd_t`.
public struct ObservationData: Sendable {
    /// Receiver sampling time (GPST).
    public var time: GNSSTime
    /// Satellite number.
    public var sat: UInt8
    /// Receiver number.
    public var rcv: UInt8
    
    /// Signal strength (0.25 dBHz).
    public var SNR: [UInt8]
    /// Loss of lock indicator.
    public var LLI: [UInt8]
    /// Code indicator (CODE_???).
    public var code: [GNSSObservationCode]
    
    /// Observation data carrier-phase (cycle).
    public var L: [Double]
    /// Observation data pseudorange (m).
    public var P: [Double]
    /// Observation data doppler frequency (Hz).
    public var D: [Float]
    
    public init(time: GNSSTime = GNSSTime(), sat: UInt8 = 0, rcv: UInt8 = 0) {
        self.time = time
        self.sat = sat
        self.rcv = rcv
        let n = GNSSLimits.nFreq + GNSSLimits.nExObs
        self.SNR = Array(repeating: 0, count: n)
        self.LLI = Array(repeating: 0, count: n)
        self.code = Array(repeating: .none, count: n)
        self.L = Array(repeating: 0.0, count: n)
        self.P = Array(repeating: 0.0, count: n)
        self.D = Array(repeating: 0.0, count: n)
    }
}

/// Collection of observation data for an epoch.
/// Mimics `obs_t`.
public struct Observation: Sendable {
    /// Observation data records.
    public var data: [ObservationData]
    
    public init(data: [ObservationData] = []) {
        self.data = data
    }
}

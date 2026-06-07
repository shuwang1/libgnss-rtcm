/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// RTCM control and context structure.
/// Mimics `rtcm_t`.
public struct RTCMContext: Sendable {
    /// Station ID.
    public var staid: Int = 0
    /// Station health.
    public var stah: Int = 0
    /// Sequence number.
    public var seqno: Int = 0
    /// Output message type.
    public var outtype: Int = 0
    
    /// Message time.
    public var time: GNSSTime = GNSSTime()
    /// Message start time.
    public var time_s: GNSSTime = GNSSTime()
    
    /// Observation data.
    public var obs: Observation = Observation()
    /// Navigation data (ephemerides).
    public var nav: Navigation = Navigation()
    /// Station parameters.
    public var sta: Station = Station()
    
    /// SSR corrections.
    public var ssr: [SSR] = Array(repeating: SSR(), count: GNSSLimits.maxSat + 1)
    
    /// Special message.
    public var msg: String = ""
    /// Last message type description.
    public var msgType: String = ""
    
    /// Observation data complete flag (1:ok, 0:not complete).
    public var obsFlag: Int = 0
    /// Update satellite of ephemeris.
    public var ephSat: Int = 0
    
    // Internal buffer and state
    public var nbyte: Int = 0
    public var nbit: Int = 0
    public var len: Int = 0
    public var buff: Data = Data(count: 1200)
    
    /// Message count for RTCM 3.
    public var nmsg3: [UInt32] = Array(repeating: 0, count: 300)
    
    public init() {}
}

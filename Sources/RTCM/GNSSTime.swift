/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Represents a precise time in GNSS systems.
/// Mimics the `gtime_t` struct from RTKLIB.
public struct GNSSTime: Equatable, Comparable, Sendable {
    /// Time in seconds since the Unix epoch (January 1, 1970).
    public var time: Int64
    /// Fraction of a second under 1 s.
    public var sec: Double
    
    public init(time: Int64 = 0, sec: Double = 0.0) {
        self.time = time
        self.sec = sec
    }
    
    /// Adds seconds to the current time.
    public func adding(seconds: Double) -> GNSSTime {
        var t = self.time
        var s = self.sec + seconds
        let floorS = floor(s)
        t += Int64(floorS)
        s -= floorS
        return GNSSTime(time: t, sec: s)
    }
    
    /// Difference between two times (self - other) in seconds.
    public func diff(_ other: GNSSTime) -> Double {
        return Double(self.time - other.time) + self.sec - other.sec
    }
    
    public static func < (lhs: GNSSTime, rhs: GNSSTime) -> Bool {
        if lhs.time != rhs.time {
            return lhs.time < rhs.time
        }
        return lhs.sec < rhs.sec
    }
}

/// Constants and conversion utilities for GNSS time systems.
public enum TimeUtilities {
    
    /// GPS time reference (January 6, 1980 00:00:00 UTC).
    public static let gpst0 = TimeUtilities.epochToTime(year: 1980, month: 1, day: 6, hour: 0, min: 0, sec: 0.0)
    
    /// BeiDou time reference (January 1, 2006 00:00:00 UTC).
    public static let bdt0 = TimeUtilities.epochToTime(year: 2006, month: 1, day: 1, hour: 0, min: 0, sec: 0.0)
    
    /// Leap seconds table (y, m, d, h, m, s, utc-gpst).
    private static let leaps: [(GNSSTime, Double)] = [
        (TimeUtilities.epochToTime(year: 2017, month: 1, day: 1), -18.0),
        (TimeUtilities.epochToTime(year: 2015, month: 7, day: 1), -17.0),
        (TimeUtilities.epochToTime(year: 2012, month: 7, day: 1), -16.0),
        (TimeUtilities.epochToTime(year: 2009, month: 1, day: 1), -15.0),
        (TimeUtilities.epochToTime(year: 2006, month: 1, day: 1), -14.0),
        (TimeUtilities.epochToTime(year: 1999, month: 1, day: 1), -13.0),
        (TimeUtilities.epochToTime(year: 1997, month: 7, day: 1), -12.0),
        (TimeUtilities.epochToTime(year: 1996, month: 1, day: 1), -11.0),
        (TimeUtilities.epochToTime(year: 1994, month: 7, day: 1), -10.0),
        (TimeUtilities.epochToTime(year: 1993, month: 7, day: 1), -9.0),
        (TimeUtilities.epochToTime(year: 1992, month: 7, day: 1), -8.0),
        (TimeUtilities.epochToTime(year: 1991, month: 1, day: 1), -7.0),
        (TimeUtilities.epochToTime(year: 1990, month: 1, day: 1), -6.0),
        (TimeUtilities.epochToTime(year: 1988, month: 1, day: 1), -5.0),
        (TimeUtilities.epochToTime(year: 1985, month: 7, day: 1), -4.0),
        (TimeUtilities.epochToTime(year: 1983, month: 7, day: 1), -3.0),
        (TimeUtilities.epochToTime(year: 1982, month: 7, day: 1), -2.0),
        (TimeUtilities.epochToTime(year: 1981, month: 7, day: 1), -1.0)
    ]
    
    /// Converts calendar day/time to `GNSSTime`.
    public static func epochToTime(year: Int, month: Int, day: Int, hour: Int = 0, min: Int = 0, sec: Double = 0.0) -> GNSSTime {
        let doy = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]
        
        if year < 1970 || year > 2099 || month < 1 || month > 12 {
            return GNSSTime()
        }
        
        // Leap year calculation for 1901-2099
        let days = (year - 1970) * 365 + (year - 1969) / 4 + doy[month - 1] + day - 2 + (year % 4 == 0 && month >= 3 ? 1 : 0)
        let totalSeconds = Int64(days) * 86400 + Int64(hour) * 3600 + Int64(min) * 60 + Int64(floor(sec))
        let fraction = sec - floor(sec)
        
        return GNSSTime(time: totalSeconds, sec: fraction)
    }
    
    /// Converts `GNSSTime` to GPS week and TOW.
    public static func timeToGPST(_ t: GNSSTime) -> (week: Int, tow: Double) {
        let sec = t.time - gpst0.time
        let week = Int(sec / (86400 * 7))
        let tow = Double(sec - Int64(week) * 86400 * 7) + t.sec
        return (week, tow)
    }
    
    /// Converts GPS week and TOW to `GNSSTime`.
    public static func gpstToTime(week: Int, tow: Double) -> GNSSTime {
        var t = gpst0
        let totalSeconds = Int64(86400 * 7 * week) + Int64(floor(tow))
        t.time += totalSeconds
        t.sec = tow - floor(tow)
        return t
    }
    
    /// Converts GPS time to UTC considering leap seconds.
    public static func gpstToUTC(_ t: GNSSTime) -> GNSSTime {
        for (leapTime, offset) in leaps {
            let tu = t.adding(seconds: offset)
            if tu.diff(leapTime) >= 0.0 {
                return tu
            }
        }
        return t
    }
    
    /// Converts UTC to GPS time considering leap seconds.
    public static func utcToGPST(_ t: GNSSTime) -> GNSSTime {
        for (leapTime, offset) in leaps {
            if t.diff(leapTime) >= 0.0 {
                return t.adding(seconds: -offset)
            }
        }
        return t
    }
}

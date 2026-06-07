/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

import Foundation

/// Low-level bit manipulation utilities for GNSS data streams.
public enum BitUtilities {
    
    /// Extracts unsigned bits from byte data.
    /// - Parameters:
    ///   - data: The source byte data.
    ///   - pos: The bit position from the start of the data (in bits).
    ///   - len: The bit length to extract (must be <= 32).
    /// - Returns: The extracted unsigned bits as a `UInt32`.
    public static func getbitu(_ data: Data, pos: Int, len: Int) -> UInt32 {
        var result: UInt32 = 0
        for i in pos..<(pos + len) {
            let byteIndex = i / 8
            guard byteIndex < data.count else { break }
            let bitInByteIndex = 7 - (i % 8)
            let bit = (UInt32(data[byteIndex]) >> bitInByteIndex) & 1
            result = (result << 1) + bit
        }
        return result
    }
    
    /// Extracts signed bits from byte data.
    /// - Parameters:
    ///   - data: The source byte data.
    ///   - pos: The bit position from the start of the data (in bits).
    ///   - len: The bit length to extract (must be <= 32).
    /// - Returns: The extracted signed bits as an `Int32`.
    public static func getbits(_ data: Data, pos: Int, len: Int) -> Int32 {
        let bits = getbitu(data, pos: pos, len: len)
        if len <= 0 || len >= 32 || (bits & (1 << (len - 1))) == 0 {
            return Int32(bits)
        }
        // Sign extension
        return Int32(bitPattern: bits | (0xFFFFFFFF << len))
    }
}

/// A stateful reader for bit-level extraction from a data stream.
public final class BitReader {
    private let data: Data
    private var bitOffset: Int = 0
    
    public init(data: Data) {
        self.data = data
    }
    
    /// Current bit position in the stream.
    public var position: Int { bitOffset }
    
    /// Number of remaining bits in the stream.
    public var remainingBits: Int { (data.count * 8) - bitOffset }
    
    /// Skips a specified number of bits.
    public func skip(bits: Int) {
        bitOffset += bits
    }
    
    /// Reads unsigned bits and returns as `Int`.
    public func readInt(bits: Int) -> Int? {
        guard bits > 0 && bits <= 64 else { return nil }
        guard bitOffset + bits <= data.count * 8 else { return nil }
        
        var result: UInt64 = 0
        for i in 0..<bits {
            let currentBitIndex = bitOffset + i
            let byteIndex = currentBitIndex / 8
            let bitInByteIndex = 7 - (currentBitIndex % 8)
            if (data[byteIndex] & (1 << bitInByteIndex)) != 0 {
                result |= (UInt64(1) << (bits - 1 - i))
            }
        }
        
        bitOffset += bits
        return Int(result)
    }
    
    /// Reads signed bits and returns as `Int64`.
    public func readInt64(bits: Int) -> Int64? {
        guard bits > 0 && bits <= 64 else { return nil }
        guard bitOffset + bits <= data.count * 8 else { return nil }
        
        var result: UInt64 = 0
        for i in 0..<bits {
            let currentBitIndex = bitOffset + i
            let byteIndex = currentBitIndex / 8
            let bitInByteIndex = 7 - (currentBitIndex % 8)
            if (data[byteIndex] & (1 << bitInByteIndex)) != 0 {
                result |= (UInt64(1) << (bits - 1 - i))
            }
        }
        
        bitOffset += bits
        
        // Handle signed bit for sign extension
        if bits < 64 {
            let signBit = UInt64(1) << (bits - 1)
            if (result & signBit) != 0 {
                let mask = (UInt64.max << bits)
                result |= mask
            }
        }
        
        return Int64(bitPattern: result)
    }
    
    /// Reads unsigned bits and scales by a factor.
    public func readFloat(bits: Int, factor: Double) -> Double {
        guard let val = readInt(bits: bits) else { return 0.0 }
        return Double(val) * factor
    }
    
    /// Reads signed bits and scales by a factor.
    public func readFloatSign(bits: Int, factor: Double) -> Double {
        guard let val = readInt64(bits: bits) else { return 0.0 }
        return Double(val) * factor
    }
}

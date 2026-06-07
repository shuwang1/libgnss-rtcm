# libgnss-rtcm-swift

[![CI](https://github.com/shuwang1/Orientable-libgnss-rtcm/actions/workflows/ci.yml/badge.svg)](https://github.com/shuwang1/Orientable-libgnss-rtcm/actions/workflows/ci.yml)
[![Documentation](https://github.com/shuwang1/libgnss-rtcm-swift/actions/workflows/documentation.yml/badge.svg)](https://shuwang1.github.io/libgnss-rtcm-swift/documentation/rtcm)

`libgnss-rtcm-swift` is a high-performance, type-safe Swift library for decoding and encoding RTCM (Radio Technical Commission for Maritime Services) messages. 

It is a modern Swift port of the core logic of a Orientable AI internal C project, optimized for real-time differential GNSS (DGNSS) and RTK applications.

## Philosophy

**"Festina lente"** (Hasten slowly). This library prioritizes architectural correctness and numerical precision without sacrificing the performance required for real-time GNSS processing.

## Features

- **RTCM3 Decoder**: Stream-based decoding with automatic synchronization, length validation, and CRC24Q verification.
- **Bit-level Precision**: Specialized `BitReader` and `BitWriter` for efficient field extraction and packing.
- **GNSS Time Engine**: Robust handling of GPS and BeiDou epochs, including leap second conversions and Time of Week (TOW) calculations.
- **Type-safe Models**: Idiomatic Swift structures for Ephemeris, Observations, Station coordinates, and SSR corrections.
- **Concurrency Ready**: Designed for Swift 6 structured concurrency with `Sendable` compliance.
- **Numerical Parity**: Verified against the reference C implementation to ensure floating-point precision in orbital parameters and coordinate transforms.

## Documentation

Comprehensive API documentation is available at [shuwang1.github.io/libgnss-rtcm-swift](https://shuwang1.github.io/libgnss-rtcm-swift/documentation/rtcm).

You can also generate documentation locally:
```bash
swift package generate-documentation --target RTCM
```

## Supported Messages (RTCM3)

- **1005/1006**: Stationary RTK Reference Station ARP.
- **1019**: GPS Broadcast Ephemeris.
- *More coming soon (MSM support in progress).*

## Quick Start

### Decoding a Stream

```swift
import Foundation
import RTCM

let decoder = RTCM3Decoder()

// Simulate receiving bytes from a socket or serial port
let byteStream: [UInt8] = [0xD3, 0x00, 0x13, ...] 

for byte in byteStream {
    let status = decoder.inputByte(byte)
    
    switch status {
    case .station:
        print("Received Station ID: \(decoder.context.staid)")
        print("Coordinates: \(decoder.context.sta.pos)")
    case .ephemeris:
        if let latestEph = decoder.context.nav.eph.last {
            print("Received Ephemeris for Sat: \(latestEph.sat)")
        }
    case .noMessage:
        break // Synchronization or partial message
    default:
        print("Message type \(decoder.context.outtype) received.")
    }
}
```

## Project Structure

- `Sources/RTCM`: Core logic and decoder.
- `Sources/RTCM/Models`: Data structures for GNSS data.
- `Sources/RTCM/BitUtilities.swift`: Low-level bit manipulation.
- `Sources/RTCM/GNSSTime.swift`: GNSS-specific time conversions.
- `Tests/RTCMTests`: Unit tests and validation suites.

## License

This project is licensed under a proprietary and confidential license - see the [LICENSE.md](LICENSE.md) file for details.

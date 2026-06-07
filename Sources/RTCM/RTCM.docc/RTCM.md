# ``RTCM``

A high-performance Swift library for decoding and encoding RTCM messages.

## Overview

`libgnss-rtcm-swift` provides a modern, type-safe interface for handling Radio Technical Commission for Maritime Services (RTCM) data streams. It is designed for use in real-time GNSS applications, such as NTRIP clients and RTK positioning engines.

### Key Components

- **Decoding**: Use the ``RTCM3Decoder`` to parse raw byte streams into structured GNSS data.
- **Data Models**: Explore the ``Observation``, ``Ephemeris``, and ``Station`` structures for working with satellite and receiver information.
- **Utilities**: Perform bit-level manipulations with ``BitReader`` and time conversions with ``GNSSTime``.

## Topics

### Message Processing

- ``RTCM3Decoder``
- ``RTCMStatus``
- ``RTCMContext``

### GNSS Data Models

- ``Observation``
- ``ObservationData``
- ``Ephemeris``
- ``GLONASSEphemeris``
- ``Station``
- ``SSR``

### Low-level Utilities

- ``BitReader``
- ``BitUtilities``
- ``CRC``
- ``GNSSTime``
- ``TimeUtilities``
- ``GNSSMath``
- ``SatelliteUtilities``

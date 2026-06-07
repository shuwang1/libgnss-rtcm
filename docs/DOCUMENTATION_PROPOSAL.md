# Documentation Strategy for libgnss-rtcm-swift

To ensure `libgnss-rtcm-swift` is professional, maintainable, and easy to integrate, I propose the following documentation frameworks and practices.

## 1. Swift-DocC (Primary API Reference)
**Framework**: [Apple's DocC](https://github.com/apple/swift-docc)
**Why**: It is the industry standard for Swift. It integrates directly with Xcode and can generate rich, interactive documentation websites and specialized "Tutorials".

### Implementation:
- **Documentation Catalogs**: Add a `Sources/RTCM/RTCM.docc` directory for high-level articles, images, and tutorials.
- **In-Source Comments**: Use triple-slash `///` Markdown comments for all public symbols.
- **CI/CD Integration**: Automate documentation building and hosting (e.g., via GitHub Pages) using the `swift-docc-plugin`.

**Command to Build**:
```bash
swift package --allow-writing-to-package-directory generate-documentation --target RTCM
```

---

## 2. Architectural Decision Records (ADR)
**Framework**: [adr-tools](https://github.com/npryce/adr-tools) or simple Markdown templates.
**Why**: GNSS processing involves many complex "magic numbers" and specific math choices (e.g., why WGS84 vs ITRF). ADRs track the "Why" behind these technical decisions.

### Implementation:
- Create a `docs/adr` directory.
- Each major architectural shift (e.g., moving from a class-based decoder to an actor-based one) gets a numbered ADR file.

---

## 3. GitHub Pages + Swift-DocC Plugin
**Framework**: [swift-docc-plugin](https://github.com/apple/swift-docc-plugin)
**Why**: Seamlessly hosts the DocC-generated site on GitHub Pages.

### Setup in `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
]
```

---

## 4. Benchmarking & Performance Docs
**Framework**: [Swift Benchmark](https://github.com/google/swift-benchmark)
**Why**: RTCM decoding is often in the critical path of real-time systems. Documenting performance metrics (latency/throughput) is vital.

### Implementation:
- Create a `Benchmarks` target.
- Include a `docs/PERFORMANCE.md` file summarizing throughput for common message types (1005, 1019, MSM7).

---

## 5. Formal Specification Mapping
**Why**: RTCM is a regulated standard. The code should map directly to the RTCM 10403.x specification documents.

### Implementation:
- In `BitReader` calls, include comments referencing the specific Data Field (DF) numbers from the RTCM spec.
- Example: `let staid = reader.readInt(bits: 12) // DF003: Reference Station ID`

## Recommendation
I recommend starting with **Swift-DocC**. It provides the most immediate value for developers using the library. I can set up the basic DocC catalog and the `swift-docc-plugin` dependency if you'd like.

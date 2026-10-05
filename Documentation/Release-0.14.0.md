<!-- Prepared GitHub release notes; publish only after the release checks are complete. -->
# YoutubeKit 0.14.0

This release updates compatibility with current Xcode and Swift toolchains, improves player diagnostics,
and adds iOS client identity to Data API requests while preserving existing public APIs from 0.13.0.

## Changes

- Support Swift 5 and Swift 6 language modes with synchronized networking state and credentials.
- Derive the embedded player's default Referer from the host app's bundle ID.
- Add optional raw error-code and blocked-autoplay callbacks, including support for reporting error 153.
- Support fractional-second seeking while retaining the existing `Int` overload and method references.
- Fit the bundled player HTML to the device viewport in portrait and landscape.
- Automatically send `X-Ios-Bundle-Identifier` for API-key requests, preserving explicit header values and OAuth behavior.
- Add regression coverage for networking, resources, player callbacks, seeking, and the Example scene lifecycle.
- Document retired YouTube features with English deprecation messages and migration guidance.

## Compatibility and upgrading

- Minimum deployment target: **iOS 13**, unchanged from 0.13.0.
- SwiftPM tools version: **5.3**; default library language mode: **Swift 5**.
- Existing delegates, enum cases, completion handlers, and `Decodable` responses remain supported.
- Custom player base URLs continue to take precedence. Hosts without a valid bundle ID should provide an explicit identity URL.
- Deprecated APIs remain callable but cannot restore server features removed by YouTube. New warnings may affect builds that treat warnings as errors.
- CocoaPods users upgrading from **0.9.0** need **iOS 13**, compared with iOS 11 in that version. Apps supporting iOS 11 or 12 should retain a compatible older version.
- SwiftPM is recommended for new integrations. Carthage has no maintained shared framework target in this repository.

## Known limitations

- Looping a time range may not preserve its start/end boundaries on subsequent iterations ([#35](https://github.com/rinov/YoutubeKit/issues/35)).
- The reported playback error 4 remains under investigation ([#111](https://github.com/rinov/YoutubeKit/issues/111)); this release does not claim to resolve it.
- The header change addresses missing iOS identity for restricted keys ([#89](https://github.com/rinov/YoutubeKit/issues/89)). Other API configuration and quota errors can still return 403.
- Playback availability, autoplay, branding, and quality remain subject to YouTube and WebKit behavior.

See the [README](https://github.com/rinov/YoutubeKit/blob/0.14.0/README.md) for installation and migration guidance.

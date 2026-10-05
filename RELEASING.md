<!-- Maintainer release procedure: validate the merged source before publishing either distribution. -->
# Preparing 0.14.0

The release notes are prepared in [Documentation/Release-0.14.0.md](Documentation/Release-0.14.0.md).
This preparation does not create a tag or publish a release.

## Validate the candidate

- [ ] Merge the release preparation PR and confirm the merged commit's CI passes on Xcode 26/27 in Swift 5/6 modes.
- [ ] Confirm `YoutubeKit.podspec`, the README installation example, release title, and tag all use `0.14.0`.
- [ ] Run package and hosted Example tests with `python3 Scripts/run-tests.py --language-mode 5` and `--language-mode 6`.
- [ ] Run `pod lib lint YoutubeKit.podspec --allow-warnings` and repeat with `--use-libraries`; inspect all warnings.
- [ ] In a consumer app, confirm bundled player HTML loads through SwiftPM and CocoaPods, and the privacy manifest is included.
- [ ] Run the live checks below and record the app bundle ID, device, iOS version, commit, video ID, and outcome without credentials.

Deprecation warnings are expected in compatibility tests and the retained legacy quality query.
`--allow-warnings` does not make build errors acceptable. Inspect any new warning before publishing.
Xcode 27 CI uses an iOS 15 validation deployment target; shipped manifests continue to specify iOS 13.
Automated tests do not establish playback behavior on physical devices or authenticate with a real restricted key.

## Live checks

Use an embeddable public video and the Example app on a physical iPhone, including a current iOS version.
API-key configuration is only needed for the Data API check; embedded playback needs no API key.

- [ ] Start playback with a user tap; confirm video, audio, state callbacks, and advancing playback time.
- [ ] Check autoplay or the blocked-autoplay callback followed by successful manual playback.
- [ ] Enter/exit fullscreen, rotate, background/foreground the app, then close and reopen the player.
- [ ] Check whole-second and fractional-second seeking. YouTube may seek to a nearby keyframe.
- [ ] Check the raw error callback for a video that cannot be embedded. Do not equate error 4 with error 153.
- [ ] Validate a real iOS-restricted key as described in [API key restrictions](Documentation/API-key-restrictions.md).

If playback fails, capture the raw code and environment details and investigate before publication.
Do not mark #111 or #89 resolved solely because offline tests pass.

## Publish after validation

Use a clean checkout of the merged `master`. Inspect the selected commit before tagging.
The following commands publish externally and are intentionally separate from preparation:

```sh
git switch master
git pull --ff-only origin master
git status --short
git log -1 --oneline
git tag -a 0.14.0 -m "YoutubeKit 0.14.0"
git push origin 0.14.0
pod spec lint YoutubeKit.podspec --allow-warnings
gh release create 0.14.0 --verify-tag --title "YoutubeKit 0.14.0" --notes-file Documentation/Release-0.14.0.md
pod trunk push YoutubeKit.podspec --allow-warnings
```

`pod spec lint` verifies the tagged remote source, unlike `pod lib lint`, which checks the local tree.
Publishing to CocoaPods requires the maintainer's authenticated trunk session.
Check `pod trunk info YoutubeKit` and the GitHub release afterward; both should list 0.14.0.
Finally, install 0.14.0 in clean SwiftPM and CocoaPods consumer projects and repeat the resource-loading check.
Do not move an already published tag; prepare a new patch release if a correction is needed.

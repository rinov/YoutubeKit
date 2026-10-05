<!-- Data API authentication guidance for apps upgrading to automatic iOS client identity. -->
# iOS API key restrictions

Enable the YouTube Data API v3 in the Google Cloud project that owns your key.
Restrict the key to that API and add the calling app's bundle ID under the **iOS apps** application restriction.
Set the key with `YoutubeKit.shared.setAPIKey(...)` before sending a request.

Starting in 0.14.0, API-key requests built by `makeURLRequest()` automatically send
`X-Ios-Bundle-Identifier` using `Bundle.main.bundleIdentifier` exactly as configured in the app.
This is separate from the HTTPS Referer used by the embedded video player.
Google documents the required header in its [iOS API key restrictions guide](https://docs.cloud.google.com/docs/authentication/api-keys#ios_apps).

## Existing integrations

- Custom `Requestable.headerField` values take precedence, regardless of header-name casing.
- An explicitly empty identity header is preserved, although it will not satisfy an iOS restriction.
- If the host has no bundle ID, no identity header is added. A custom `Requestable` can supply one through `headerField`.
- OAuth requests retain their existing bearer-token behavior; no identity header is automatically added to them.
- API key query parameters, custom headers, request bodies, and public method signatures remain unchanged.

## Checking a restricted key

Use a valid key restricted to the test app's bundle ID and the YouTube Data API v3.
Send a `SearchListRequest(part: [.id], searchQuery: "music")` and confirm a successful response.
Also verify that a different, unlisted app ID is rejected by Google.
Never commit the key or include it in an issue, screenshot, or request log.

If a request still returns 403, check the configured bundle ID, API enablement, API restrictions,
and quota. The identity-header fix alone does not resolve every cause of 403.
Keep the restrictions enabled while diagnosing the failure.

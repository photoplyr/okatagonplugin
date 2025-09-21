## 0.1.3

- Use `registerWith()` for Android and WebKit implementations so the native side is re-bound after hot restarts and background isolates, fixing `PigeonInternalInstanceManager.clear` channel errors.
- Keep the example app in sync with the plugin runtime registration changes.

## 0.1.2

- Ensure platform-specific WebView implementations are registered to avoid runtime channel errors on iOS/macOS and Android.
- Configure `OkatagonAgentView` to set inline media playback and navigation gestures for WebKit, and disable Android user-gesture requirements for media playback.
- Add explicit dependencies on `webview_flutter_android`, `webview_flutter_wkwebview`, and the platform interface to support the above changes.
- Update the example app to initialize the correct WebView platform before running.

## 0.1.1

- Bump version for updated package metadata.

## 0.1.0

- Initial public release of the Okatagon plugin.
- Provides `OkatagonAgentView` widget for embedding Oktagon agents via WebView.
- Includes demo application, widget test, and integration test coverage.

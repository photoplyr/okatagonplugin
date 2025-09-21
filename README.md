# Okatagon Flutter Plugin

Embed [Okatagon](https://okatagon.com) conversational agents directly into your Flutter applications with a single widget. The plugin wraps an Oktagon agent experience inside a platform WebView while exposing configuration hooks for advanced use cases.

## Features

- Zero-setup `OkatagonAgentView` widget that renders a live agent conversation
- Customizable base URL, query parameters, and HTTP headers
- Built-in loading and error states with retry handling
- Works across Android and iOS using the official `webview_flutter` package

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  okatagonplugin: ^0.1.0
```

Then run `flutter pub get`.

## Usage

Import the package and drop the widget into your layout:

```dart
import 'package:okatagonplugin/okatagonplugin.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Chat with Okatagon')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: OkatagonAgentView(
          agentId: 'YOUR_AGENT_ID',
        ),
      ),
    );
  }
}
```

### Advanced configuration

| Option | Description |
| --- | --- |
| `agentId` | Required Oktagon agent identifier. |
| `baseUrl` | Override the default Oktagon data endpoint. |
| `queryParameters` | Merge extra query parameters into the agent URL. |
| `customHeaders` | Supply HTTP headers (e.g., auth tokens). |
| `height` / `width` | Force a fixed size for the WebView container. |
| `onError` | Listen for WebView resource errors and implement custom handling. |

## Example app

The bundled `example/` application demonstrates a minimal integration. Run it with:

```bash
cd example
flutter run
```

## Testing

- Run package tests: `flutter test`
- Run the example widget test: `cd example && flutter test test/widget_test.dart`
- Run integration tests: `cd example && flutter test integration_test`

## Publishing

1. Update the version in `pubspec.yaml` and the CHANGELOG.
2. Execute `dart pub publish --dry-run` to validate the package.
3. Publish with `dart pub publish` when everything looks good.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.

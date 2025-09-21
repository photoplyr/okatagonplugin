import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:okatagonplugin/okatagonplugin.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        AndroidWebViewPlatform.registerWith();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        WebKitWebViewPlatform.registerWith();
        break;
      default:
        break;
    }
  }

  runApp(const OkatagonExampleApp());
}

class OkatagonExampleApp extends StatelessWidget {
  const OkatagonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okatagon Agent Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const OkatagonAgentDemoPage(),
    );
  }
}

class OkatagonAgentDemoPage extends StatelessWidget {
  const OkatagonAgentDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Okatagon Agent Preview')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: OkatagonAgentView(
          agentId: 'YOUR_AGENT_ID',
        ),
      ),
    );
  }
}

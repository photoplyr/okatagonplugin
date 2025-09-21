import 'package:flutter/material.dart';
import 'package:okatagonplugin/okatagonplugin.dart';

void main() {
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

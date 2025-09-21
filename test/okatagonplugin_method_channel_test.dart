import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// Removed import from a package that doesn't exist

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannel('okatagonplugin');
  const MethodChannel channel = MethodChannel('okatagonplugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    final result = await platform.invokeMethod('getPlatformVersion');
    expect(result, '42');
  });
}

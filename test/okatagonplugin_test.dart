import 'package:flutter_test/flutter_test.dart';
import 'package:okatagonplugin/okatagonplugin.dart';

void main() {
  test('buildAgentUri uses defaults and overrides', () {
    const view = OkatagonAgentView(agentId: '123');
    final uri = view.buildAgentUri();

    expect(uri.toString(), 'https://data.oktagonapp.com/agentView/123?embed=true&chat=true&audio=true');
  });

  test('buildAgentUri merges base url and params', () {
    const view = OkatagonAgentView(
      agentId: 'abc',
      baseUrl: 'https://example.com/base/',
      queryParameters: {'foo': 'bar'},
    );

    final uri = view.buildAgentUri();

    expect(uri.scheme, 'https');
    expect(uri.host, 'example.com');
    expect(uri.path, '/base/agentView/abc');
    expect(uri.queryParameters['foo'], 'bar');
    expect(uri.queryParameters['embed'], 'true');
    expect(uri.queryParameters['audio'], 'true');
  });
}

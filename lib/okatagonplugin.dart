import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// Renders an Oktagon agent inside a platform WebView.
class OkatagonAgentView extends StatefulWidget {
  const OkatagonAgentView({
    super.key,
    required this.agentId,
    this.baseUrl = 'https://data.oktagonapp.com',
    this.queryParameters = const <String, String>{},
    this.customHeaders,
    this.height,
    this.width,
    this.onError,
  });

  /// The Oktagon agent identifier to embed in the view.
  final String agentId;

  /// Base URL for the Oktagon data domain.
  final String baseUrl;

  /// Additional query parameters merged onto the required defaults.
  final Map<String, String> queryParameters;

  /// Optional HTTP headers supplied with the initial request.
  final Map<String, String>? customHeaders;

  /// Optional fixed height for the WebView container.
  final double? height;

  /// Optional fixed width for the WebView container.
  final double? width;

  /// Callback invoked when the WebView reports a resource error.
  final void Function(WebResourceError error)? onError;

  @override
  State<OkatagonAgentView> createState() => _OkatagonAgentViewState();

  @visibleForTesting
  Uri buildAgentUri() => _buildAgentUri(
        baseUrl: baseUrl,
        agentId: agentId,
        extraParams: queryParameters,
      );
}

class _OkatagonAgentViewState extends State<OkatagonAgentView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  WebResourceError? _lastError;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _loadAgent();
  }

  @override
  void didUpdateWidget(OkatagonAgentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agentId != widget.agentId ||
        oldWidget.baseUrl != widget.baseUrl ||
        !_mapsEqual(oldWidget.queryParameters, widget.queryParameters) ||
        !_mapsEqual(oldWidget.customHeaders, widget.customHeaders)) {
      _loadAgent();
    }
  }

  void _loadAgent() {
    final uri = widget.buildAgentUri();
    final headers = widget.customHeaders ?? {};
    setState(() {
      _isLoading = true;
      _lastError = null;
    });

    unawaited(_controller.loadRequest(uri, headers: headers));
  }

  WebViewController _createController() {
    _ensurePlatformImplementation();

    final controller = WebViewController.fromPlatformCreationParams(
      _platformParams(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _lastError = null;
            });
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _lastError = error;
                _isLoading = false;
              });
            }
            widget.onError?.call(error);
          },
        ),
      );

    if (controller.platform is WebKitWebViewController) {
      final webKitController = controller.platform as WebKitWebViewController;
      webKitController
        ..setAllowsBackForwardNavigationGestures(true);
    }

    if (controller.platform is AndroidWebViewController) {
      final androidController =
          controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    return controller;
  }

  void _ensurePlatformImplementation() {
    if (kIsWeb) {
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        if (WebViewPlatform.instance is! AndroidWebViewPlatform) {
          AndroidWebViewPlatform.registerWith();
        }
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (WebViewPlatform.instance is! WebKitWebViewPlatform) {
          WebKitWebViewPlatform.registerWith();
        }
        break;
      default:
        break;
    }
  }

  PlatformWebViewControllerCreationParams _platformParams() {
    if (!kIsWeb) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return  WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: <PlaybackMediaTypes>{},
          );
        case TargetPlatform.android:
          return  AndroidWebViewControllerCreationParams();
        default:
          break;
      }
    }

    return const PlatformWebViewControllerCreationParams();
  }

  @override
  Widget build(BuildContext context) {
    final widgetStack = Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Container(
            color: Theme.of(context).colorScheme.surface,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        if (_lastError case final error?)
          Container(
            color: Theme.of(context).colorScheme.surface,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load Oktagon agent.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (error.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    error.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAgent,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      ],
    );

    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: kIsWeb
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: widgetStack,
    );
  }

  bool _mapsEqual(Map<String, String>? a, Map<String, String>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}

Uri _buildAgentUri({
  required String baseUrl,
  required String agentId,
  Map<String, String> extraParams = const <String, String>{},
}) {
  final base = Uri.parse(baseUrl);
  final params = <String, String>{
    'embed': 'true',
    'chat': 'true',
    'audio': 'true',
    ...extraParams,
  };

  final segments = <String>[...
      base.pathSegments.where((segment) => segment.isNotEmpty),
    'agentView',
    agentId,
  ];

  return base.replace(
    pathSegments: segments,
    queryParameters: params,
  );
}

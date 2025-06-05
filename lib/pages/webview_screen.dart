import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../widgets/shared/appbar.dart';

class WebviewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const WebviewScreen({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).colorScheme.surface)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    mixpanel.track('Viewed Screen - Webview', properties: {
      'url': widget.url,
      'title': widget.title,
    });

    return Scaffold(
      appBar: CustomAppBar(
        preferredSize: const Size.fromHeight(50),
        title: widget.title,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
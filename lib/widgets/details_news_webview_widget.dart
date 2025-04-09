import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsNewsWebviewWidget extends StatefulWidget {
  const DetailsNewsWebviewWidget({super.key, required this.url});

  final String url;

  @override
  State<DetailsNewsWebviewWidget> createState() =>
      _DetailsNewsWebviewWidgetState();
}

class _DetailsNewsWebviewWidgetState extends State<DetailsNewsWebviewWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}

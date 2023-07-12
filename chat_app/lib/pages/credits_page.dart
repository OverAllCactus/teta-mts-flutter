import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreditsPage extends StatefulWidget {
  CreditsPage();
  @override
  createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse('https://flutter.dev/'));

  _CreditsPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
            child: WebViewWidget(
          controller: _controller,
        ))
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MyWebView());
}

class MyWebView extends StatelessWidget {
  MyWebView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewApp(),
    );
  }
}

//initial url
final _url = 'https://www.google.com';

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}


class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    _initWebViewController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      );
  }

  void _initWebViewController() {
    //initialize the webview
    _controller = WebViewController()

    //allow javascript run
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {
          },
          onPageFinished: (String url) {
          },
          onWebResourceError: (WebResourceError error) async {
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(_url),
      );
  }

}

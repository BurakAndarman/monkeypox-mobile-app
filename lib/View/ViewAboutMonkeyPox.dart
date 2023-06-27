import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ViewWalkthrough.dart';

class ViewAboutMonkeypox extends StatefulWidget {
  const ViewAboutMonkeypox({super.key});

  @override
  State<ViewAboutMonkeypox> createState() => _ViewAboutMonkeypoxState();
}

class _ViewAboutMonkeypoxState extends State<ViewAboutMonkeypox> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://www.who.int/news-room/fact-sheets/detail/monkeypox')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.who.int/news-room/fact-sheets/detail/monkeypox'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Monkeypox Disease'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: WebViewWidget(controller: controller),
      ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => ViewWalkthrough()),
                  ),
                );
              },
              icon: const Icon(Icons.done),
              label: const Text('I Read and Continue'),
              backgroundColor: Colors.green,
            ),
    );
  }
}

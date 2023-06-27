import 'package:ai_monkeypox/View/ViewAboutMonkeyPox.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewInfo extends StatefulWidget {
  const ViewInfo({super.key});

  @override
  State<ViewInfo> createState() => _ViewInfoState();
}

class _ViewInfoState extends State<ViewInfo> {
  Future<void> savePreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isAcceptWarnsAndTerms", true);
  }

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://sukrucanavci.github.io/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://sukrucanavci.github.io/'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('EULA'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: WebViewWidget(controller: controller),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          savePreferences();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const ViewAboutMonkeypox()),
            ),
          );
        },
        icon: const Icon(Icons.done),
        label: const Text('Accept EULA and Continue'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

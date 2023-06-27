import 'dart:io';

import 'package:ai_monkeypox/View/ViewOptions.dart';
import 'package:ai_monkeypox/View/ViewWalkthrough.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NetworkErrorDialog.dart';
import 'View/ViewInfo.dart';

void main() {
  runApp(const MonkeyPox());
}

class MonkeyPox extends StatelessWidget {
  const MonkeyPox({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartingWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartingWidget extends StatefulWidget {
  const StartingWidget({super.key});

  @override
  State<StartingWidget> createState() => _StartingWidgetState();
}

class _StartingWidgetState extends State<StartingWidget> {
  late Widget startingWidget;
  var _isLoading = true;

  Future<bool> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _isLoading = false;
      return false;
    } else {
      return true;
    }
  }

  Future setStartingWidget() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var isAccept = sharedPreferences.getBool("isAcceptWarnsAndTerms");
    startingWidget =
        (isAccept ?? false) ? const ViewWalkthrough() : const ViewInfo();
  }

  goStartingWidget() {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => startingWidget)));
  }

  @override
  void initState() {
    super.initState();
    hasNetwork().then((value) => {
          setStartingWidget().then((value) => {goStartingWidget()})
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : TextButton(
                child: const Text("Check Internet Connection\n and Continue",
                    textAlign: TextAlign.center),
                onPressed: () async {
                  final connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.none) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => NetworkErrorDialog(
                        onPressed: () async {
                          final connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please turn on your wifi or mobile data')));
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  } else {
                    setStartingWidget().then((value) => {goStartingWidget()});
                  }
                },
              ),
      ),
    );
  }
}

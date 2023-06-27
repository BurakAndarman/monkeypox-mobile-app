import 'package:flutter/material.dart';

import 'ViewInfo.dart';

class ViewSplash extends StatefulWidget {
  const ViewSplash({super.key});

  @override
  State<ViewSplash> createState() => _ViewSplashState();
}

class _ViewSplashState extends State<ViewSplash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ViewInfo()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'AI Monkeypox',
              style: Theme.of(context).textTheme.headline6,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

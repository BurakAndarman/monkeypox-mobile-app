import 'package:ai_monkeypox/View/ViewOptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';

class ViewWalkthrough extends StatefulWidget {
  const ViewWalkthrough({super.key});

  @override
  State<ViewWalkthrough> createState() => _ViewWalkthroughState();
}

class _ViewWalkthroughState extends State<ViewWalkthrough> {
  final List<OnbordingData> list = const [
    OnbordingData(
      image: AssetImage("assets/sample-1.png"),
      titleText:
          Text("Can Give Wrong Result ❌", style: TextStyle(color: Colors.red)),
      descText: Text(
        "You should take a clean photo of your skin in close-up and without any objects around.",
        textAlign: TextAlign.center,
      ),
    ),
    OnbordingData(
      image: AssetImage("assets/sample-2.png"),
      titleText: Text("Can Give Correct Result ✅",
          style: TextStyle(color: Colors.green)),
      descText: Text(
        "Photos like the one above will give you more accurate results.",
        textAlign: TextAlign.center,
      ),
    ),
    OnbordingData(
      image: AssetImage("assets/doctors.jpg"),
      titleText: Text("", style: TextStyle(color: Colors.green)),
      descText: Text(
        "This application doesn't give definite results. If you think you are sick, you should go to the nearest health facility.",
        textAlign: TextAlign.center,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreen(
        onbordingDataList: list,
        colors: const [Colors.green],
        pageRoute: MaterialPageRoute(
          builder: (context) => ViewOptions(),
        ),
        nextButton: const Text("NEXT", style: TextStyle(color: Colors.green)),
        lastButton: const Text("GOT IT", style: TextStyle(color: Colors.green)),
        skipButton: const Text("SKIP", style: TextStyle(color: Colors.black87)),
        selectedDotColor: Colors.green,
        unSelectdDotColor: Colors.grey,
      ),
    );
  }
}

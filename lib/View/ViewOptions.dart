import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as XImage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ViewAnalysis.dart';

class ViewOptions extends StatefulWidget {
  static const String id = 'monkeypox_classifier';

  @override
  _ViewOptionsState createState() => _ViewOptionsState();
}

class _ViewOptionsState extends State<ViewOptions> {
  final picker = ImagePicker();
  Image _image = Image.asset('assets/transparent.png');
  bool _loading = false;
  bool _isMpox = false;
  String _output = "Please choose one of the options below.";

  pickImageFromCamera() async {
    if (await Permission.storage.request().isGranted) {
      var imageFile = await picker.pickImage(source: ImageSource.camera);

      if (imageFile == null) return null;

      final image = XImage.decodeImage(File(imageFile.path).readAsBytesSync())!;
      final thumbnail = XImage.copyResize(image, width: 224, height: 224);

      Directory root = await getTemporaryDirectory();
      File('${root.path}/thumbnail.jpg')
          .writeAsBytesSync(XImage.encodeJpg(thumbnail));

      var _file = File('${root.path}/thumbnail.jpg');
      setState(() {
        _image = Image.file(File(imageFile.path));
        _loading = true;
      });

      upload(_file);
    }
  }

  pickGalleryImage() async {
    var imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) return null;

    final image = XImage.decodeImage(File(imageFile.path).readAsBytesSync())!;
    final thumbnail = XImage.copyResize(image, width: 224, height: 224);
    if (await Permission.storage.request().isGranted) {
      Directory root = await getTemporaryDirectory();
      File('${root.path}/thumbnail.jpg')
          .writeAsBytesSync(XImage.encodeJpg(thumbnail));

      var _file = File('${root.path}/thumbnail.jpg');
      setState(() {
        _image = Image.file(File(imageFile.path));
        _loading = true;
      });

      upload(_file);
    }
  }

  upload(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://sukrucanavci.pythonanywhere.com/predict");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var resultMap = jsonDecode(respStr);
    if (resultMap["predicted"] == "Monkey Pox") {
      _output = "It's Monkey Pox with ${resultMap["possibility"]} possibility";
      _isMpox = true;
    } else if (resultMap["predicted"] == "Others") {
      _output =
          "It isn't Monkey Pox with ${resultMap["possibility"]} possibility";
      _isMpox = false;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), //<-- SEE HERE
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                  }, // <-- SEE HERE
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Monkeypox AI'),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: _isMpox ? Colors.red : Colors.green,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ViewAnalysis()),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: _loading
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDancingSquare(
                            itemBuilder: (_, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.green
                                        : Colors.black38),
                              );
                            },
                            size: 50),
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: const Text(
                                "Please wait, the process is in progress...")),
                      ],
                    ),
                  )
                : Container(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 32),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              height:  MediaQuery.of(context).size.height*0.4,
                              child: _image,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '$_output',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Spacer(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  OutlinedButton(
                                    onPressed: pickImageFromCamera,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(54),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.camera,
                                              color: _isMpox
                                                  ? Colors.red
                                                  : Colors.green,
                                            )),
                                        const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Open The Camera And Take a Photo",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  OutlinedButton(
                                    onPressed: pickGalleryImage,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(54),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.folder_open,
                                              color: _isMpox
                                                  ? Colors.red
                                                  : Colors.green,
                                            )),
                                        const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                "Choose Image From Gallery",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                )))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}

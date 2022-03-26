
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  File? imageFile;

  Uint8List? receivedImage;

  void takePicture() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      receivedImage = null;
      imageFile = File(pickedFile!.path);
    });
  }

  void sendPicture(File image) async {
    var url = "https://visaitazsamongkol.herokuapp.com/image";
    var imageByte = image.readAsBytesSync();
    var req = http.MultipartRequest('POST', Uri.parse(url));
    req.files.add(
      http.MultipartFile(
        'image',
        imageFile!.readAsBytes().asStream(),
        imageFile!.lengthSync(),
        filename: "flutter_image"
      )
    );
    var res = await req.send()
    Uint8List tmp = await res.stream.to
    setState(() {
      receivedImage = tmp;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          imageFile != null && receivedImage == null?
              Container(
                child: Image.file(imageFile!),
              ) :
              Icon(
                Icons.camera_enhance_rounded,
                color: Colors.green,
                size: MediaQuery.of(context).size.width * 0.6,
              ),
          receivedImage != null ?
          Container(
              child: Image.memory(receivedImage!)
          ):
          SizedBox(
            height: 50,
          ),
          Padding(
              padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              child: Text('Take Picture'),
              onPressed: () {
                takePicture();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple),
                padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16))
              )
            )
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: Text('send picture'),
                  onPressed: () {
                    sendPicture(imageFile!);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.cyan),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16))
                  )
              )
          ),
        ],
      )
    );
  }
}

/*
import 'dart:convert';

import 'package:capstone/api_response.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'connect/laravel.dart';
import 'dart:typed_data';
class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? _pickedImageBytes;

  Future<void> _pickAndUploadImage() async {
    final ImageSource? source = await showMaterialModalBottomSheet<ImageSource>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                  iconSize: 75,
                  color: Colors.blue,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                const Text('Camera'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  iconSize: 75,
                  color: Colors.blue,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                const Text('Gallery'),
              ],
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: source,
        maxHeight: 500,
        maxWidth: 500,
      );

      if (pickedImage != null) {
        final byteData = await pickedImage.readAsBytes();

        setState(() {
          _pickedImageBytes = byteData;
        });

        String base64Image = base64Encode(_pickedImageBytes!);

        ApiResponse response = await pictureAdd(base64Image);

        if (response.error == null) {
          print('Image uploaded successfully: ${response.data}');
        } else {

          print('Upload failed: ${response.error}');
        }
      } else {
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: (){
                _pickAndUploadImage();
              },
              child: Text('data'),
            ),
          ),
          if(_pickedImageBytes == null)
            SizedBox(
              height: 130,
              width: 100,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: ColorStyle.tertiary,
                        shape: BoxShape.circle
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/user.png'),
                      radius: 50,
                    ),
                  ),
                  Positioned(
                      top: 70,
                      left: 70,
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorStyle.tertiary,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _pickAndUploadImage();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                              weight: 50,
                            ),
                          )))
                ],
              ),
            ),
          if (_pickedImageBytes != null)
            SizedBox(
              height: 130,
              width: 100,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: ColorStyle.tertiary,
                          shape: BoxShape.circle
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage: MemoryImage(_pickedImageBytes!),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 70,
                      left: 70,
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorStyle.tertiary,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _pickAndUploadImage();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                              weight: 50,
                            ),
                          )))
                ],
              ),
            ),
          
          Image.network('$picaddress/66d0371469345.jpg')
        ],
      )
    );
  }
}

*/

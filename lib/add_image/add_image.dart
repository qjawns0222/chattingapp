import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Add_image extends StatefulWidget {
  const Add_image(this.addImageFunc,{Key? key}) : super(key: key);
  final Function(File pickedImage) addImageFunc;
  @override
  State<Add_image> createState() => _Add_imageState();
}

class _Add_imageState extends State<Add_image> {
  File? pickedImage;


  void _pickImage() async {
    print('a$pickedImage');
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
   widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 150,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage:
                  pickedImage != null ? FileImage(pickedImage!) : null,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: OutlinedButton(
                onPressed: () {
                  _pickImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image),
                    Text('Add icon'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            TextButton(
              onPressed: () {
                print('b$pickedImage');
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close),
                  Text('Close'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

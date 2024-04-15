import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));

  
}

Future<File?> pickimagefromgallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showsnackbar(context, 'Something Went Wrong!');
    }
    return image;
  }


Future<File?> pickvideofromgallery(BuildContext context) async {
    File? video;
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } catch (e) {
      showsnackbar(context, 'Something Went Wrong!');
    }
    return video;
  }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Tailor_views/home_screen/home.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  String _selectedTailorType = 'Female Tailor';
  List<File> _selectedImages = [];
  File? _selectedProfileImage;

  @override
  void initState() {
    _nameController = TextEditingController();
    _detailsController = TextEditingController();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty && pickedImages.length <= 5) {
      setState(() {
        _selectedImages =
            pickedImages.map((image) => File(image.path)).toList();
      });
    } else {
      // Show a snackbar or toast message indicating the image selection limit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select between 1 and 5 images.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedProfileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: redColor,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _selectProfileImage,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: _selectedProfileImage != null
                          ? CircleAvatar(
                              radius: 56,
                              backgroundImage:
                                  FileImage(_selectedProfileImage!),
                            )
                          : Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: redColor,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _detailsController,
              decoration: InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _minPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Min Price'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _maxPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Max Price'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTailorType,
              items: ['Male Tailor', 'Female Tailor']
                  .map((type) => DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTailorType = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Tailor Type'),
            ),
            SizedBox(height: 20),
            const Text(
              'Upload Images of Pre-built Clothes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectImages,
              child: Text('Select Images'),
            ),
            const SizedBox(height: 10),
            _selectedImages.isEmpty
                ? Text('No images selected')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Images:'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages.map((image) {
                          return SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _detailsController.text.isNotEmpty &&
                    _selectedTailorType.isNotEmpty &&
                    _selectedImages.isNotEmpty &&
                    _selectedImages.length <= 5) {
                  // All mandatory fields are filled, proceed with saving the profile
                  _saveProfile();
                } else {
                  // Show a snackbar indicating that all fields are mandatory
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please fill in all fields and select between 1 and 5 images.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // text color
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    double minPrice = double.parse(_minPriceController.text);
    double maxPrice = double.parse(_maxPriceController.text);
    try {
      // Upload profile picture if selected
      String profileImageUrl = '';
      if (_selectedProfileImage != null) {
        profileImageUrl = await _uploadImage(_selectedProfileImage!,
            folderName: 'profile_pictures');
      }

      // Update fields in Firebase Firestore
      await FirebaseFirestore.instance
          .collection('Tusers')
          .doc(currentUser?.uid)
          .update({
        'name': _nameController.text.toString(),
        'details': _detailsController.text.toString(),
        'T_type': _selectedTailorType.toString(),
        'ProfileImageurl': profileImageUrl,
        'profileSetup': true,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      });

      // Store selected images
      List<String> imageUrls = [];
      for (var image in _selectedImages) {
        // Upload image to Firebase Storage
        String imageUrl =
            await _uploadImage(image, folderName: 'Tailor_Pictures');
        imageUrls.add(imageUrl);
      }

      // Update image URLs in Firestore
      await FirebaseFirestore.instance
          .collection('Tusers')
          .doc(currentUser?.uid)
          .update({
        'images': imageUrls,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
      Get.offAll(Home_Tailor());
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<String> _uploadImage(File image, {String? folderName}) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      String folder = folderName ?? 'tailor_images'; // Default folder name
      Reference reference = FirebaseStorage.instance.ref().child(
          '$folder/${currentUser?.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload file to Firebase Storage
      UploadTask uploadTask = reference.putFile(image);

      // Get download URL of uploaded image
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      throw error;
    }
  }
}

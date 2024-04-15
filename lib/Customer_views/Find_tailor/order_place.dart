import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/Find_tailor/map_page.dart';
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TailorInfoScreen extends StatefulWidget {
  @override
  _TailorInfoScreenState createState() => _TailorInfoScreenState();
}

class _TailorInfoScreenState extends State<TailorInfoScreen> {
  void _placeOrder() async {
    if (selectedTailorType.isNotEmpty &&
        clothesImages.isNotEmpty &&
        designImages.isNotEmpty) {
      // Upload images to Firebase Storage and get the download URLs
      List<String> clothesImageUrls = await _uploadImages(clothesImages);
      List<String> designImageUrls = await _uploadImages(designImages);

      log(clothesImageUrls.first.toString());

      // Create an Order object
      Orderr order = Orderr(
        tailorId: '', // Assign this value when the tailor confirms the order
        tailorType: selectedTailorType,
        clothesImageUrls: clothesImageUrls,
        designImageUrls: designImageUrls,
        details: detailsController.text,
        expId: '',
        customerId: currentUser!.uid,
        status: '',
        ratting: 0.00,
        price: double.parse(priceController.text),
      );

      DocumentReference orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toMap());
      String orderId = orderRef.id;

      // Navigate to the map page (you need to implement the map page navigation logic)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapPage(
                    orderId: orderId,
                  )));
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      String imageName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Unique name for each image

      try {
        // Upload image to Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/$imageName');
        UploadTask uploadTask = storageReference.putFile(image);

        // Get download URL
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add the download URL to the list
        imageUrls.add(downloadUrl);
      } catch (error) {
        print('Error uploading image: $error');
        // Handle error, e.g., show a message to the user
      }
    }

    return imageUrls;
  }

  String selectedTailorType = '';
  List<File> clothesImages = [];
  List<File> designImages = [];
  TextEditingController detailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<void> _pickImage(
      ImageSource source, List<File> imageList, int maxImages) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      if (imageList.length < maxImages) {
        setState(() {
          imageList.add(File(pickedFile.path));
        });
      } else {
        // Notify the user that the maximum number of images has been reached
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum $maxImages images allowed.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _removeImage(List<File> imageList, File image) {
    setState(() {
      imageList.remove(image);
    });
  }

  Widget _buildImageList(List<File> imageList) {
    return SizedBox(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    imageList[index],
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () => _removeImage(imageList, imageList[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Tell Us about Your Order",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Tailor Type:',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            _buildTailorTypeButton('Male'),
                            SizedBox(width: 16.0),
                            _buildTailorTypeButton('Female'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter price',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clothes Section (Up to 4 Images):',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 8.0),
                        _buildImageList(clothesImages),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () =>
                              _pickImage(ImageSource.gallery, clothesImages, 4),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Text(
                            'Add Clothes Image',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expected Design Section (Up to 2 Images):',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 8.0),
                        _buildImageList(designImages),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () =>
                              _pickImage(ImageSource.gallery, designImages, 2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Text(
                            'Add Design Image',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details about the Design:',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: detailsController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter details here...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle place order logic here
                    _placeOrder();
                    print('Placing Order...');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTailorTypeButton(String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTailorType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTailorType == type ? Colors.red : Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Text(
        type,
        style: TextStyle(
            color: selectedTailorType == type ? Colors.white : Colors.black),
      ),
    );
  }
}

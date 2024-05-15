import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/Find_tailor/map_page.dart';
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        appBar: AppBar(
          backgroundColor: redColor, // Red app bar background color
          elevation: 10, // Add elevation for drop shadow
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white70, // You can change the border color here
                  width: 2.0, // You can adjust the border width here
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  'Tell us about your order',
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: whiteColor,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Tailor Type:',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 8.0),
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
                ),
                const SizedBox(height: 16.0),
                Container(
                  color: whiteColor,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'PKR 2000',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  color: whiteColor,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            onPressed: () => _pickImage(
                                ImageSource.gallery, clothesImages, 4),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              backgroundColor: whiteColor,
                              side: BorderSide(color: redColor),
                            ),
                            child: const Text(
                              'Add clothes Photo',
                              style: TextStyle(color: redColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  color: whiteColor,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            onPressed: () => _pickImage(
                                ImageSource.gallery, designImages, 2),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              backgroundColor: whiteColor,
                              side: BorderSide(color: redColor),
                            ),
                            child: const Text(
                              'Add Design Photo',
                              style: TextStyle(color: redColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  color: whiteColor,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter details here...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    child: ElevatedButton(
                      onPressed: () {
                        const SpinKitPulse(
                          color: Colors.red,
                          size: 100.0,
                        );
                        // Handle place order logic here
                        _placeOrder();
                        print('Placing Order...');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
        backgroundColor: selectedTailorType == type ? Colors.red : Colors.white,
        side: const BorderSide(color: redColor),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Text(
        type,
        style: TextStyle(
            color: selectedTailorType == type ? Colors.white : redColor),
      ),
    );
  }
}

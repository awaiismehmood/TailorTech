import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Tailor_views/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/Model_Classes/customer_class.dart';
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  final Orderr order;
  final Customer getCustomer;

  DetailScreen({Key? key, required this.order, required this.getCustomer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: redColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            SizedBox(height: 20.0),
            Center(
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
                      _buildDetailItem('Customer Name', getCustomer.name),
                      SizedBox(height: 10.0),
                      _buildDetailItem('Details of Order', order.details),
                      SizedBox(height: 10.0),
                      _buildDetailItem('Tailor Type', order.tailorType),
                      SizedBox(height: 10.0),
                      _buildDetailItem('Price', order.price.toString()),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
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
                      'Clothes Images:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _buildImageSection(order.clothesImageUrls),
                    SizedBox(height: 20.0),
                    Text(
                      'Designed Images:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _buildImageSection(order.designImageUrls),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300, //150,
                  child: ElevatedButton(
                    onPressed: () {
                      deleteOrder(order);
                    },
                    child: Text(
                      'Decline',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 150,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               title: Text("Message Tailor"),
                //               content: Text(
                //                   "Only customers can message tailors first."),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context)
                //                         .pop(); // Close the dialog
                //                   },
                //                   child: Text("OK"),
                //                 ),
                //               ],
                //             );
                //           });
                //     },
                //     child: Text(
                //       'Chat',
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  acceptOrder(order.expId, order);
                },
                child: Text(
                  'Accept',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: getCustomer.profileImageUrl != " "
                ? NetworkImage(getCustomer.profileImageUrl)
                : null,
            child:
                getCustomer.profileImageUrl == " " ? Icon(Icons.person) : null,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          getCustomer.name,
          style: TextStyle(fontSize: 26.0, fontFamily: bold),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildImageSection(List<String> imageUrls) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImageDialog(context, imageUrls[index]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrls[index],
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(imageUrl),
        );
      },
    );
  }

  Future<void> acceptOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'tailorId': tailorId,
      'status': 'Running',
      'expectedTailorId': "",
    });

    Get.offAll(() => Home_Tailor());
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    Get.offAll(() => Home_Tailor());
  }
}

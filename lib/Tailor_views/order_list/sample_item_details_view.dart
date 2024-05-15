import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/home_screen/home.dart';
import 'package:dashboard/Customer_views/measurements/showMeasure.dart';
import 'package:dashboard/Customer_views/services/chatt/chat_home.dart';
import 'package:dashboard/Model_Classes/customer_class.dart';
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:dashboard/Tailor_views/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class SampleItemDetailsView extends StatefulWidget {
  final Orderr order;
  final bool isTailor;

  const SampleItemDetailsView(
      {super.key, required this.order, required this.isTailor});

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  late Customer getCustomer;
  bool _isLoading = true;

  @override
  void initState() {
    getCustomerData(widget.order.customerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: redColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _isLoading == true
            ? const SpinKitPulse(
                color: Colors.red,
                size: 100.0,
              )
            : Column(
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
                            _buildDetailItem(
                                'Details of Order', widget.order.details),
                            SizedBox(height: 10.0),
                            _buildDetailItem(
                                'Tailor Type', widget.order.tailorType),
                            SizedBox(height: 10.0),
                            _buildDetailItem(
                                'Price', widget.order.price.toString()),
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
                          _buildImageSection(widget.order.clothesImageUrls),
                          SizedBox(height: 20.0),
                          Text(
                            'Designed Images:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          _buildImageSection(widget.order.designImageUrls),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     SizedBox(
                  //       width: 150,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           deleteOrder(widget.order);
                  //         },
                  //         child: Text(
                  //           'Decline',
                  //           style: TextStyle(fontSize: 16.0),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 150,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           // Handle button tap
                  //         },
                  //         child: Text(
                  //           'Chat',
                  //           style: TextStyle(fontSize: 16.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10.0),
                  button(),
                ],
              ),
      ),
    );
  }

  Widget button() {
    if (widget.isTailor == true) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                CompleteOrder(widget.order.expId, widget.order);
              },
              child: Text(
                'Complete',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => showMeasure(
                            id: widget.order.customerId, isCustomer: false)));
              },
              child: const Text(
                'View Mesaurements',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                deleteOrder(widget.order);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  // Assuming you have the tailor's ID available
                  String tailorId = widget.order.expId;
                  // Get the current customer's ID
                  String customerId = currentUser!.uid;
                  // Add tailor's ID to the customer's chat list
                  await addToChatList(customerId, tailorId);
                  // Navigate to the chat page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => chatHome()));
                } catch (e) {
                  print("Error: $e");
                  // Handle error
                }
              },
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      );
    }
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

  Future<void> getCustomerData(String customerId) async {
    try {
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(customerId)
          .get();

      if (customerSnapshot.exists) {
        // If customer exists, update the state with the retrieved data
        setState(() {
          getCustomer = Customer.fromFirestore(customerSnapshot);
          _isLoading = false; // Set loading flag to false
        });
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      // Handle exception if customer not found or any other error occurs
      print(e.toString());
    }
  }

  Future<void> CompleteOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': 'completed',
    });

    Get.offAll(() => Home_Tailor());
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    Get.offAll(() => Home());
  }

  Future<void> addToChatList(String customerId, String tailorId) async {
    try {
      // Get the current chat list of the customer
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(customerId)
          .get();

      if (customerSnapshot.exists) {
        // Extract chatList and cast it to List<String>
        List<String> currentChatList = List<String>.from(
            (customerSnapshot.data() as Map<String, dynamic>?)?['chatlist']
                    ?.cast<String>() ??
                []);

        // Add tailor's ID only if it's not already in the list
        if (!currentChatList.contains(tailorId)) {
          currentChatList.add(tailorId);

          // Update the document with the modified chat list
          await FirebaseFirestore.instance
              .collection(usersCollection)
              .doc(customerId)
              .update({'chatlist': currentChatList});

          addToTailorChatList(customerId, tailorId);
        }
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      print(e.toString());
      throw e; // Re-throw the exception for handling in calling function
    }
  }

  Future<void> addToTailorChatList(String customerId, String tailorId) async {
    try {
      // Get the current chat list of the customer
      DocumentSnapshot TailorSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection1)
          .doc(tailorId)
          .get();

      if (TailorSnapshot.exists) {
        // Extract chatList and cast it to List<String>
        List<String> currentChatList = List<String>.from(
            (TailorSnapshot.data() as Map<String, dynamic>?)?['chatlist']
                    ?.cast<String>() ??
                []);

        // Add tailor's ID only if it's not already in the list
        if (!currentChatList.contains(customerId)) {
          currentChatList.add(customerId);

          // Update the document with the modified chat list
          await FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(tailorId)
              .update({'chatlist': currentChatList});
        }
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      print(e.toString());
      throw e; // Re-throw the exception for handling in calling function
    }
  }
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Model_Classes/customer_class.dart';
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/controllers/order_controller.dart';
import 'package:dashboard/widgets_common/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderAcceptScreen extends StatefulWidget {
  const OrderAcceptScreen({super.key});

  @override
  State<OrderAcceptScreen> createState() => _OrderAcceptScreenState();
}

class _OrderAcceptScreenState extends State<OrderAcceptScreen> {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Orders')),
        ),
        body: OrderList(),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  // final OrderController orderController = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('expectedTailorId', isEqualTo: currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Extract orders from the snapshot
            List<Orderr> orders = snapshot.data!.docs
                .map((doc) {
                  if (doc.data() != null) {
                    return Orderr.fromDocument(doc);
                  } else {
                    return null;
                  }
                })
                .whereType<Orderr>()
                .toList();
            log("Cleared till now 1");
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Customer>(
                    future: getCustomerData(orders[index].customerId),
                    builder: (context, customerSnapshot) {
                      if (customerSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (customerSnapshot.hasError) {
                        return Text('Error: ${customerSnapshot.error}');
                      }
                      Customer customer = customerSnapshot.data!;
                      log("Cleared till now");

                      return OrderCard(
                        order: orders[index],
                        customer: customer,
                        onRemoveClicked: () {
                          // Remove the clicked card from the list
                          setState(() {
                            orders.removeAt(index);
                          });
                        },
                        acceptOrder: () {
                          acceptOrder(orders[index].expId, orders[index]);
                        },
                        deleteOrder: () {
                          deleteOrder(orders[index]);
                        },
                      );
                    });
              },
            );
          }),
    );
  }

  Future<Customer> getCustomerData(String customerId) async {
    log("iam in getCustomer DAta");
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(customerId)
        .get();

    if (customerSnapshot.exists) {
      return Customer.fromFirestore(customerSnapshot);
    } else {
      throw Exception('Customer not found');
    }
  }

  Future<void> acceptOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'tailorId': tailorId,
      'status': 'Running',
      'expectedTailorId': "",
    });
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }
}

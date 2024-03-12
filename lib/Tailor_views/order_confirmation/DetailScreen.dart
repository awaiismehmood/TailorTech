import 'package:dashboard/Model_Classes/order_class.dart';
//import 'package:dashboard/Tailor_views/order_confirmation/Orders.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Orderr order;

  const DetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Customer Name:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Product Type: ',
              style: TextStyle(fontSize: 20),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

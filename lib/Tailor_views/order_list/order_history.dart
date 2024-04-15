import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sample_item_details_view.dart';

enum OrderStatus {
  all,
  completed,
  Running,
}

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderStatus _selectedStatus = OrderStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(color: whiteColor, fontFamily: bold),
        ),
        backgroundColor: redColor,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigator.restorablePushNamed(context, SettingsView.routeName);
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton('All', OrderStatus.all),
              _buildFilterButton('Completed', OrderStatus.completed),
              _buildFilterButton('In Process', OrderStatus.Running),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Orderr> orders = snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      return Orderr.fromDocument(document);
                    })
                    .where((orders) => orders.tailorId == currentUser?.uid)
                    .toList();

                List<Orderr> filteredOrders = _filterOrders(orders);

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = filteredOrders[index];
                    return Card(
                      child: ListTile(
                        title: Text('Order ID: ${order.getDocumentId()}'),
                        subtitle: Text(order.details),
                        trailing: Text('Status: ${order.status}'),
                        onTap: () {
                          if (order.status != 'completed') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SampleItemDetailsView(
                                          isTailor: true,
                                          order: order,
                                        )));
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Orderr> _filterOrders(List<Orderr> orders) {
    if (_selectedStatus == OrderStatus.all) {
      return orders;
    } else {
      return orders
          .where((order) => order.status == _statusToString(_selectedStatus))
          .toList();
    }
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.Running:
        return 'Running';
      default:
        return '';
    }
  }

  Widget _buildFilterButton(String label, OrderStatus status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedStatus == status ? redColor : null,
      ),
      child: Text(
        label,
        style: TextStyle(
            color: _selectedStatus == status ? whiteColor : redColor,
            fontFamily: semibold),
      ),
    );
  }
}

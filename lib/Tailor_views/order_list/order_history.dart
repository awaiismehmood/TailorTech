// import 'package:flutter/material.dart';
// import 'Item_class.dart';
// import 'sample_item_details_view.dart';

// enum OrderStatus {
//   all,
//   pending,
//   completed,
//   inProcess,
// }

// class OrderHistory extends StatefulWidget {
//   const OrderHistory({Key? key}) : super(key: key);

//   static const routeName = '/';

//   @override
//   _OrderHistoryState createState() => _OrderHistoryState();
// }

// class _OrderHistoryState extends State<OrderHistory> {
//   List<Item> items = [
//     Item(
//       id: 1,
//       description: 'Sample Description 1',
//       price: 10.99,
//       quantity: 5,
//       status: OrderStatus.pending,
//     ),
//     Item(
//       id: 2,
//       description: 'Sample Description 2',
//       price: 20.99,
//       quantity: 3,
//       status: OrderStatus.completed,
//     ),
//     Item(
//       id: 3,
//       description: 'Sample Description 3',
//       price: 15.99,
//       quantity: 8,
//       status: OrderStatus.inProcess,
//     ),
//   ];

//   List<Item> completedItems = [];
//   OrderStatus _selectedStatus = OrderStatus.all;

//   @override
//   Widget build(BuildContext context) {
//     List<Item> filteredItems;
//     if (_selectedStatus == OrderStatus.all) {
//       filteredItems = items;
//     } else if (_selectedStatus == OrderStatus.completed) {
//       filteredItems = completedItems;
//     } else {
//       filteredItems =
//           items.where((item) => item.status == _selectedStatus).toList();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order History'),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               // Navigator.restorablePushNamed(context, SettingsView.routeName);
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.white,
//             child: ListView.builder(
//               padding: EdgeInsets.only(top: 60),
//               itemCount: filteredItems.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final item = filteredItems[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text('Customer# ${item.id}'),
//                     subtitle: Text(item.description),
//                     trailing: Text(
//                         'Amount payed: \$${item.price.toStringAsFixed(2)}'),
//                     onTap: () {
//                       if (item.status != OrderStatus.completed) {
//                         Navigator.restorablePushNamed(
//                           context,
//                           SampleItemDetailsView.routeName,
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 color: Colors.blue,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildFilterButton('All', OrderStatus.all),
//                     _buildFilterButton('Pending', OrderStatus.pending),
//                     _buildFilterButton('Completed', OrderStatus.completed),
//                     _buildFilterButton('In Process', OrderStatus.inProcess),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterButton(String label, OrderStatus status) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           _selectedStatus = status;
//         });
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _selectedStatus == status ? Colors.blue : null,
//       ),
//       child: Text(label),
//     );
//   }
// }
import 'package:dashboard/Model_Classes/order_class.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sample_item_details_view.dart';

enum OrderStatus {
  all,
  pending,
  completed,
  Running,
}

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderStatus _selectedStatus = OrderStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButton('All', OrderStatus.all),
                  _buildFilterButton('Pending', OrderStatus.pending),
                  _buildFilterButton('Completed', OrderStatus.completed),
                  _buildFilterButton('In Process', OrderStatus.Running),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Orderr> orders =
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  // ignore: unused_local_variable
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Orderr.fromDocument(document);
                }).toList();

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
                            Navigator.restorablePushNamed(
                              context,
                              SampleItemDetailsView.routeName,
                            );
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
      case OrderStatus.pending:
        return 'pending';
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
        backgroundColor: _selectedStatus == status ? Colors.blue : null,
      ),
      child: Text(label),
    );
  }
}

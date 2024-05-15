import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/home_screen/home.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'measurement_class.dart';

class showMeasure extends StatefulWidget {
  final String id;
  final bool isCustomer;
  const showMeasure({super.key, required this.id, required this.isCustomer});

  @override
  _showMeasureState createState() => _showMeasureState();
}

class _showMeasureState extends State<showMeasure> {
  CustomerMeasurements? customerMeasurements;
  bool isEditing = false;
  Future<void> gettingMeasure() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(widget.id)
        .collection('measurements')
        .doc(widget.id)
        .get();
    setState(() {
      customerMeasurements = CustomerMeasurements.fromFirebase(doc);
    });
  }

  @override
  void initState() {
    super.initState();
    gettingMeasure();
  }

  @override
  Widget build(BuildContext context) {
    return customerMeasurements == null
        ? const Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: Center(
                child: SpinKitPulse(
                  color: Colors.red,
                  size: 100.0,
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.red,
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'My Measurements',
                          style: TextStyle(
                            fontFamily: bold,
                            color: whiteColor,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      widget.isCustomer
                          ? IconButton(
                              icon: Icon(
                                isEditing ? Icons.done : Icons.edit,
                                color: whiteColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                            )
                          : Icon(Icons.accessible_forward_rounded),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 20.0),
                  //   child: const Text(
                  //     'wahab',
                  //     style: TextStyle(
                  //       fontSize: 24.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Color.fromARGB(255, 255, 255, 255),
                  //     ),
                  //   ),
                  // ),
                  _buildMeasurementContainer(
                      'Height', customerMeasurements?.height ?? 0.00),
                  _buildMeasurementContainer(
                      'Waist', customerMeasurements?.waist ?? 0.00),
                  _buildMeasurementContainer(
                      'Belly', customerMeasurements?.belly ?? 0.00),
                  _buildMeasurementContainer(
                      'Chest', customerMeasurements?.chest ?? 0.00),
                  _buildMeasurementContainer(
                      'Wrist', customerMeasurements?.wrist ?? 0.00),
                  _buildMeasurementContainer(
                      'Neck', customerMeasurements?.neck ?? 0.00),
                  _buildMeasurementContainer(
                      'Arm', customerMeasurements?.arm ?? 0.00),
                  _buildMeasurementContainer(
                      'Thigh', customerMeasurements?.thigh ?? 0.00),
                  _buildMeasurementContainer(
                      'Shoulder', customerMeasurements?.shoulder ?? 0.00),
                  _buildMeasurementContainer(
                      'Hips', customerMeasurements?.hips ?? 0.00),
                ],
              ),
            ),
            floatingActionButton: widget.isCustomer
                ? FloatingActionButton(
                    onPressed: () {
                      Get.offAll(Home());
                      customerMeasurements?.saveToFirestore();

                      // setState(() {
                      //   customerMeasurements.saveToFirestore();
                      // });
                      // Save measurements to profile or perform any other action here
                      print('Measurements saved: $customerMeasurements');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Measurements saved!'),
                      ));
                    },
                    child: Icon(Icons.save),
                  )
                : FloatingActionButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: Icon(Icons.home_filled),
                  ));
  }

  Widget _buildMeasurementContainer(String label, double value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color.fromARGB(
            255, 255, 255, 255), // Set container color to light red
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(122, 209, 200, 200).withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.linear_scale),
          SizedBox(width: 8.0),
          Text(label,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(width: 20.0),
          if (isEditing)
            Expanded(
              child: TextFormField(
                initialValue: value.toString(),
                onChanged: (newValue) {
                  setState(() {
                    // Update the corresponding measurement value
                    if (label == 'Height') {
                      customerMeasurements?.height = double.parse(newValue);
                    } else if (label == 'Waist') {
                      customerMeasurements?.waist = double.parse(newValue);
                    } else if (label == 'Belly') {
                      customerMeasurements?.belly = double.parse(newValue);
                    } else if (label == 'Chest') {
                      customerMeasurements?.chest = double.parse(newValue);
                    } else if (label == 'Wrist') {
                      customerMeasurements?.wrist = double.parse(newValue);
                    } else if (label == 'Neck') {
                      customerMeasurements?.neck = double.parse(newValue);
                    } else if (label == 'Arm') {
                      customerMeasurements?.arm = double.parse(newValue);
                    } else if (label == 'Thigh') {
                      customerMeasurements?.thigh = double.parse(newValue);
                    } else if (label == 'Shoulder') {
                      customerMeasurements?.shoulder = double.parse(newValue);
                    } else if (label == 'Hips') {
                      customerMeasurements?.hips = double.parse(newValue);
                    }
                  });
                },
              ),
            )
          else
            Text(value.toString()),
        ],
      ),
    );
  }
}

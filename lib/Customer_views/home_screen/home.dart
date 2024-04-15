import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/Profile/customer_profile.dart';
import 'package:dashboard/Model_Classes/customer_class.dart';
import 'package:dashboard/consts/firebase_const.dart';
import 'package:dashboard/Customer_views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controllers/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Customer customer;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        customer = Customer.fromFirestore(doc);
      });
    } else {
      print('Customer not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navBarItem = [
      GButton(
        icon: Icons.dashboard,
        text: "Dashboard",
      ),
      GButton(
        icon: Icons.person_off_outlined,
        text: "Profile",
      ),
    ];
    var navBody = [
      HomePage(
        customer: customer,
      ),
      ProfileScreenCustomer(
        customer: customer,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Obx(() => Expanded(
                child: navBody.elementAt(controller.currNavIndex.value),
              ))
        ],
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(blurRadius: 30, color: Colors.black.withOpacity(0.3))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
            child: GNav(
              rippleColor: Colors.white,
              hoverColor: Colors.white,
              tabBorderRadius: 30,
              selectedIndex: controller.currNavIndex.value,
              color: Colors.black,
              tabs: navBarItem,
              gap: 8,
              backgroundColor: Colors.transparent,
              // tabMargin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              activeColor: Colors.black,
              padding: EdgeInsets.all(16),
              tabBackgroundColor: Colors.black.withOpacity(0.02),
              tabShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                )
              ],
              onTabChange: (value) {
                controller.currNavIndex.value = value;
              },
            ),
          ),
        ),
      ),
    );
  }
}

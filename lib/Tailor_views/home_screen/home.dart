import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Model_Classes/tailor_class.dart';
import 'package:dashboard/Tailor_views/Profile/profilepage.dart';
import 'package:dashboard/Tailor_views/home_screen/home_screen.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controllers/home_controller.dart';

class Home_Tailor extends StatefulWidget {
  const Home_Tailor({super.key});

  @override
  State<Home_Tailor> createState() => _Home_TailorState();
}

class _Home_TailorState extends State<Home_Tailor> {
  late Tailor tailor;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection1)
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        tailor = Tailor.fromFirestore1(doc);
      });
    } else {
      print('Tailor not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController1());
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
      HomePage_Tailor(
        tailor: tailor,
      ),
      ProfilePage_Tailor(
        tailor: tailor,
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

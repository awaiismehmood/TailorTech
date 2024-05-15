import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Model_Classes/tailor_class.dart';
// import 'package:dashboard/Tailor_views/Profile/profilepage.dart';
import 'package:dashboard/Tailor_views/home_screen/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:dashboard/Tailor_views/Profile/profile.dart';
//import 'package:dashboard/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:location/location.dart';

import '../../controllers/home_controller.dart';

// ignore: camel_case_types
class Home_Tailor extends StatefulWidget {
  const Home_Tailor({super.key});

  @override
  State<Home_Tailor> createState() => _Home_TailorState();
}

class _Home_TailorState extends State<Home_Tailor> {
  late Tailor tailor;
  var controller = Get.put(AuthController());
  final Location _locationController = Location();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    getLocationUpdates();
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection1)
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        tailor = Tailor.fromFirestore1(doc);
        isLoading = false;
        print("Location:");
        print(tailor.latitude);
      });
    } else {
      isLoading = false;
      print('Tailor not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController1());
    var navBarItem = [
      const GButton(
        icon: Icons.dashboard,
        text: "Dashboard",
      ),
      const GButton(
        icon: Icons.person_off_outlined,
        text: "Profile",
      ),
    ];

    if (isLoading) {
      // Show loading indicator while data is being fetched
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/iconWhite.jpeg', width: 60, height: 60),
            // Loading indicator overlay
            if (isLoading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: SpinKitPulse(
                    color: redColor,
                    size: 100.0,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      var navBody = [
        HomePage_Tailor(
          tailor: tailor,
        ),
        EditProfileScreen(
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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30, color: Colors.black.withOpacity(0.3))
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
              child: GNav(
                rippleColor: redColor,
                hoverColor: Colors.white,
                tabBorderRadius: 30,
                selectedIndex: controller.currNavIndex.value,
                color: Colors.black,
                tabs: navBarItem,
                gap: 8,
                backgroundColor: Colors.transparent,
                // tabMargin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                activeColor: Colors.black,
                padding: const EdgeInsets.all(16),
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

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        CollectionReference collection =
            FirebaseFirestore.instance.collection(usersCollection1);
        await collection.doc(currentUser!.uid).update({
          'longitude': currentLocation.longitude,
          'latitude': currentLocation.latitude,
        });
      }
    });
  }
}

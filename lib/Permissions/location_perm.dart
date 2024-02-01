// import 'package:location/location.dart';
// import 'package:dashboard/controllers/auth_controller.dart';

// Future<void> getLocation(str) async {
//   AuthController auth_cont = AuthController();
//   Location location = Location();

//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;

//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return; // Location services are still not enabled, exit the function
//     }
//   }

//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return; // Location permission not granted, exit the function
//     }
//   }

//   LocationData locationData = await location.getLocation();
//   // Now you have the user's location in locationData.latitude and locationData.longitude

//   if (str == "Customer") {
//     auth_cont.storeuserData(
//         longitude: locationData.longitude, latitude: locationData.latitude);
//   } else {
//     auth_cont.storeTailorData(
//         longitude: locationData.longitude, latitude: locationData.latitude);
//   }
// }

// // // void saveLocationToFirebase(double latitude, double longitude) async {
// // //   try {
// // //     String userId = "replace_with_actual_user_id"; // Replace with the actual user ID

// // //     await FirebaseFirestore.instance.collection('user_locations').doc(userId).set({
// // //       'latitude': latitude,
// // //       'longitude': longitude,
// // //       'timestamp': FieldValue.serverTimestamp(),
// // //     });

// // //     print('Location saved to Firebase');
// // //   } catch (e) {
// // //     print('Error saving location to Firebase: $e');
// // //   }
// // // }

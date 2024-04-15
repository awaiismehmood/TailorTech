// import 'package:dashboard/chat/common/widgets/custom_button.dart';
// import 'package:dashboard/chat/features/auth/screens/login_screen.dart';
// import 'package:flutter/material.dart';

// class LandingScreen extends StatelessWidget {
//   const LandingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 50,
//             ),
//             const Text(
//               'Welcome To WhatsApp',
//               style: TextStyle(
//                 fontSize: 33,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: size.height / 9),
//             Image.asset(
//               'assets/images/bg.png',
//               height: 340,
//               width: 340,
//             ),
//             SizedBox(height: size.height / 9),
//             const Text(
//                 'Please Read Our Privacy Policy. Tap "Agree and Continue" to accept the Terms of Service.'),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: CustomButton(
//                   data: 'Agree and Continue',
//                   onpressesd: () {
//                     Navigator.of(context).pushNamed(LoginScreen.routename);
//                   }),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }

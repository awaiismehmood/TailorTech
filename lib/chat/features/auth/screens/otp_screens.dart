// import 'package:dashboard/chat/colors.dart';
// import 'package:dashboard/chat/features/auth/controller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class otpscreen extends ConsumerWidget {
//   static const String routename = '/otpscreen';
//   final String verificationid;
//   const otpscreen({super.key, required this.verificationid});

//   void verifyotp(WidgetRef ref, BuildContext context, String userotp) {
//     ref
//         .read(authcontrollerprovider)
//         .verifyotp(context, verificationid, userotp);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify Your Phone Number'),
//         elevation: 0,
//         backgroundColor: backgroundColor,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             const Text('We have sent a sms with your OTP.'),
//             SizedBox(
//               width: size.width * 0.5,
//               child: TextField(
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   hintText: '-   -   -   -   -   -',
//                   hintStyle: TextStyle(
//                     fontSize: 30,
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   if (val.length == 6) {
//                     print('verifying otp');
//                     print(val.toString());
//                     verifyotp(ref, context, val.trim());
//                   }
//                   print('executed funxtion');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:country_picker/country_picker.dart';
// import 'package:dashboard/chat/colors.dart';
// import 'package:dashboard/chat/common/widgets/custom_button.dart';
// import 'package:dashboard/chat/common/widgets/utility/utils.dart';
// import 'package:dashboard/chat/features/auth/controller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   static const routename = '/loginscreen';
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final phonecontroller = TextEditingController();
//   Country? countr;
//   @override
//   void dispose() {
//     super.dispose();
//     phonecontroller.dispose();
//   }

//   void countrypick() {
//     showCountryPicker(
//       useSafeArea: true,
//       context: context,
//       showPhoneCode:
//           true, // optional. Shows phone code before the country name.
//       onSelect: (Country country) {
//         setState(() {
//           countr = country;
//         });
//       },
//     );
//   }

//   void sendphonenum() {
//     String phonenum = phonecontroller.text.trim();
//     print('this is phone num');
//     print(phonenum.toString());
//     if (countr != null && phonenum.isNotEmpty) {
//       ref
//           .read(authcontrollerprovider)
//           .signinwithphone(context, '+${countr!.phoneCode}$phonenum');
//       print('+${countr!.phoneCode}$phonenum');
//     } else {
//       showsnackbar(context, 'Fill out all the fields');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Enter Your Phone Number',
//         ),
//         elevation: 0,
//         backgroundColor: backgroundColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               const Text('Whatsapp will need to verify your phone number.'),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: countrypick,
//                 child: const Text('Pick Country'),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   if (countr != null) Text('+${countr!.phoneCode}'),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   SizedBox(
//                     width: size.width * 0.7,
//                     child: TextField(
//                       controller: phonecontroller,
//                       decoration:
//                           const InputDecoration(hintText: 'Phone Number'),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: size.height * 0.5,
//               ),
//               SizedBox(
//                 width: 90,
//                 child: CustomButton(data: 'NEXT', onpressesd: sendphonenum),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

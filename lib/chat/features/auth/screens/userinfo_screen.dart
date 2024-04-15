// import 'dart:io';
// import 'package:dashboard/chat/features/auth/controller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../common/widgets/utility/utils.dart';

// class UserinfoScreen extends ConsumerStatefulWidget {
//   static const routename = '/userinfo';
//   const UserinfoScreen({super.key});

//   @override
//   ConsumerState<UserinfoScreen> createState() => _UserinfoScreenState();
// }

// class _UserinfoScreenState extends ConsumerState<UserinfoScreen> {
//   final TextEditingController namecontroller = TextEditingController();
//   File? image;

//   @override
//   void dispose() {
//     namecontroller.dispose();
//     super.dispose();
//   }

//   void selectimage() async {
//     image = await pickimagefromgallery(context);
//     setState(() {});
//   }

//   void storeuserdata() async {
//     String name = namecontroller.text.trim();
//     if (name.isNotEmpty) {
//       ref.read(authcontrollerprovider).saveuserdatatofirebase(
//             context,
//             name,
//             image,
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Info Screen'),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   image == null
//                       ? const CircleAvatar(
//                           backgroundImage: NetworkImage(
//                               'https://cdn-icons-png.flaticon.com/512/2815/2815428.png'),
//                           radius: 65,
//                         )
//                       : CircleAvatar(
//                           backgroundImage: FileImage(
//                             image!,
//                           ),
//                           radius: 65,
//                         ),
//                   Positioned(
//                     bottom: -15,
//                     left: 90,
//                     child: IconButton(
//                       onPressed: selectimage,
//                       icon: const Icon(
//                         Icons.add_a_photo,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: size.width * 0.8,
//                     padding: const EdgeInsets.all(20),
//                     child: TextField(
//                       controller: namecontroller,
//                       decoration: const InputDecoration(
//                         hintText: 'Please Enter Your Name',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: storeuserdata,
//                     icon: const Icon(Icons.done),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

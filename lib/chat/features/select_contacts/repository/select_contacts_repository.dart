// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashboard/chat/common/widgets/utility/utils.dart';
// import 'package:dashboard/chat/features/chat/screens/mobile_chat_screen.dart';
// import 'package:dashboard/chat/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final SelectContactRepositoryprovider = Provider(
//   (ref) => SelectContactRepository(
//     firebaseFirestore: FirebaseFirestore.instance,
//   ),
// );

// class SelectContactRepository {
//   final FirebaseFirestore firebaseFirestore;

//   SelectContactRepository({
//     required this.firebaseFirestore,
//   });

//   Future<List<Contact>> getContacts() async {
//     List<Contact> contacts = [];
//     try {
//       if (await FlutterContacts.requestPermission()) {
//         contacts = await FlutterContacts.getContacts(withProperties: true);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return contacts;
//   }

//   void selectcontact(Contact selectedContact, BuildContext context) async {
//     try {
//       var usercollection = await firebaseFirestore.collection('users').get();
//       bool isfound = false;
//       for (var documnet in usercollection.docs) {
//         var userdata = UserModel.fromMap(documnet.data());
//         String selectedphonenumber =
//             selectedContact.phones[0].number.replaceAll(' ', '');
//         if (selectedphonenumber == userdata.phonenumber) {
//           isfound = true;
//           Navigator.pushNamed(context, MobileChatScreen.routename, arguments: {
//             'name': userdata.name,
//             'uid': userdata.uid,
//           });
//         }
//       }
//       if (!isfound) {
//         showsnackbar(context, 'Contact Not Found!');
//       }
//     } catch (e) {}
//   }
// }

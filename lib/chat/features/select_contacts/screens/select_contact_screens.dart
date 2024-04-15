// import 'package:dashboard/chat/common/widgets/error.dart';
// import 'package:dashboard/chat/features/select_contacts/controller/select_contact_controller.dart';
// import 'package:dashboard/chat/widgets/Loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// class Selectcontactsscreen extends ConsumerWidget {
//   static const routename = '/contactsscreen';
//   const Selectcontactsscreen({super.key});

//   void selectcontact(
//       WidgetRef ref, Contact selectedcontact, BuildContext context) {
//     ref
//         .read(selectcontactcontrollerProvider)
//         .selectcontact(selectedcontact, context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Contact'),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.search),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.more_vert),
//           ),
//         ],
//       ),
//       body: ref.watch(getcontactsprovider).when(
//             data: (contactlist) => ListView.builder(
//               itemCount: contactlist.length,
//               itemBuilder: (context, index) {
//                 final contact = contactlist[index];

//                 return InkWell(
//                   onTap: () => selectcontact(ref, contact, context),
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: ListTile(
//                       title: Text(
//                         contact.displayName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                       leading: contact.photo == null
//                           ? null
//                           : CircleAvatar(
//                               backgroundImage: MemoryImage(contact.photo!),
//                               radius: 30,
//                             ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             error: (error, trace) => ErrorScreen(error: error.toString()),
//             loading: () => const Loader(),
//           ),
//     );
//   }
// }

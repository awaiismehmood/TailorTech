// import 'package:dashboard/chat/features/select_contacts/repository/select_contacts_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final getcontactsprovider = FutureProvider((ref) {
//   final selectContactRepository = ref.watch(SelectContactRepositoryprovider);
//   return selectContactRepository.getContacts();
// });

// final selectcontactcontrollerProvider = Provider((ref) {
//   final selectContactRepository = ref.watch(SelectContactRepositoryprovider);
//   return selectcontactcontroller(
//       ref: ref, selectContactRepository: selectContactRepository);
// });

// class selectcontactcontroller {
//   final ProviderRef ref;
//   final SelectContactRepository selectContactRepository;

//   selectcontactcontroller(
//       {required this.ref, required this.selectContactRepository});

//   // void selectcontact(Contact selectedcontact, BuildContext context) {
//     selectContactRepository.selectcontact(selectedcontact, context);
//   }
// }

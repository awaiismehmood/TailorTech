import 'package:dashboard/chat/features/chat/controller/chat_controller.dart';
import 'package:dashboard/chat/models/chat_contact.dart';
import 'package:dashboard/chat/models/message.dart';
import 'package:dashboard/chat/widgets/Loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<chatContact>>(
          stream: ref.watch(ChatcontrollerProvider).chatcontacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
//           final data = snapshot.data;
//           print(ref.watch(ChatcontrollerProvider).chatcontacts().toString());
//  print('contacts Snapshotdata');
//         print(data);
//     if (data == null || data.isEmpty) {
//       return const Text('No data available'); // Handle empty or null data.
//     }
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatcontactdata = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MobileChatScreen.routename,
                              arguments: {
                                'name': chatcontactdata.name,
                                'uid': chatcontactdata.contactid,
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            textColor: Colors.black,
                            title: Text(
                              chatcontactdata.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatcontactdata.lastmsg,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatcontactdata.profilepic,
                              ),
                              radius: 30,
                            ),
                            trailing: SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: StreamBuilder<List<Message>>(
                                        stream: ref
                                            .read(ChatcontrollerProvider)
                                            .chatStream(
                                                chatcontactdata.contactid),
                                        builder: (context, snapshot) {
                                          var length = snapshot.data!.length;
                                          var lastitem = length - 1;
                                          var data1 = snapshot.data![lastitem];
                                          if (data1.Senderid ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid) {
                                            return const CircleAvatar(
                                              radius: 0,
                                              backgroundColor: Colors.green,
                                            );
                                          }
                                          return CircleAvatar(
                                            radius: data1.isseen ? 0 : 7,
                                            backgroundColor: Colors.green,
                                          );
                                        }),
                                  ),
                                  Text(
                                    DateFormat.Hm()
                                        .format(chatcontactdata.timesent),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        indent: 85,
                        thickness: 0.1,
                      ),
                    ],
                  );
                },
              );
            }

            return const Text('No data available');
          }),
    );
  }
}

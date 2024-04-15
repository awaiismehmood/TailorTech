// ignore_for_file: unused_local_variable

import 'package:dashboard/chat/features/chat/controller/chat_controller.dart';
import 'package:dashboard/chat/features/chat/repository/chat_repository.dart';
import 'package:dashboard/chat/features/chat/widgets/my_message_card.dart';
import 'package:dashboard/chat/features/chat/widgets/sender_message_card.dart';
import 'package:dashboard/chat/models/message.dart';
import 'package:dashboard/chat/widgets/Loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  // final ProviderRef ref;
  // final chatrepository chatrepos;
  final String receiveuserid;
  const ChatList({super.key, required this.receiveuserid});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messagecontroller = ScrollController();

  @override
  void dispose() {
    messagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatprovider = Provider((ref) {
      final chatp =
          ref.watch(chatrepositoryProvider).getchatStream(widget.receiveuserid);
      // return ChatList(receiveuserid:  '',ref:  ref,chatrepos:  chatrepository );
    });

    return StreamBuilder<List<Message>>(
        stream:
            ref.read(ChatcontrollerProvider).chatStream(widget.receiveuserid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messagecontroller
                .jumpTo(messagecontroller.position.maxScrollExtent);
          });
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            print('data from cchat list listview builder');
            print(widget.receiveuserid);
            return ListView.builder(
              shrinkWrap: true,
              controller: messagecontroller,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messagedata = snapshot.data![index];
                final timesent = DateFormat.Hm().format(messagedata.timesent);
                if (!messagedata.isseen &&
                    messagedata.recieverid ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(ChatcontrollerProvider).setmessageseen(
                      context, widget.receiveuserid, messagedata.messageid);
                }
                if (messagedata.Senderid ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  print(messagedata.Text);
                  return MyMessageCard(
                    message: messagedata.Text,
                    date: timesent,
                    msgenum: messagedata.type,
                    isSeen: messagedata.isseen,
                  );
                }
                print(messagedata.Text);
                return SenderMessageCard(
                  message: messagedata.Text,
                  date: timesent,
                  msgenum: messagedata.type,
                );
              },
            );
          }
          return const Loader();
        });
  }
}

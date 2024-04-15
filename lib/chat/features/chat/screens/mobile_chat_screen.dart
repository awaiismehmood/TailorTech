import 'package:dashboard/chat/features/auth/controller/auth_controller.dart';
import 'package:dashboard/chat/features/chat/widgets/bottom_chat_field.dart';
import 'package:dashboard/chat/models/user_model.dart';
import 'package:dashboard/chat/widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../colors.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routename = '/chat_screen';
  final String name;
  final String uid;

  const MobileChatScreen({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: AppBar(
                backgroundColor: appBarColor,
                title: StreamBuilder<UserModel>(
                  stream: ref.watch(authcontrollerprovider).userdatabyid(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(children: [
                      Text(name),
                      Text(
                        snapshot.data!.online ? 'online' : ' ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    ]);
                  },
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.video_call),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(receiveuserid: uid),
            ),
            bottomchatscreen(
              recieverUserid: uid,
            ),
          ],
        ),
      ),
    );
  }
}

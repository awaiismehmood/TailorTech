import 'dart:io';

import 'package:dashboard/chat/common/enums/msg_enum.dart';
import 'package:dashboard/chat/features/auth/controller/auth_controller.dart';
import 'package:dashboard/chat/features/chat/repository/chat_repository.dart';
import 'package:dashboard/chat/models/chat_contact.dart';
import 'package:dashboard/chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChatcontrollerProvider = Provider((ref) {
  final chatrepository = ref.watch(chatrepositoryProvider);
  return Chatcontroller(chatrepos: chatrepository, ref: ref);
});

class Chatcontroller {
  final chatrepository chatrepos;
  final ProviderRef ref;

  Chatcontroller({required this.chatrepos, required this.ref});

  void sendtextmsg({
    required BuildContext context,
    required String Text,
    required String receiveruid,
  }) {
    ref.read(userdataAuthprovider).whenData(
          (value) => chatrepos.sendtextmsg(
            context: context,
            text: Text,
            recieveruid: receiveruid,
            senderuser: value!,
          ),
        );
  }

  Stream<List<chatContact>> chatcontacts() {
    return chatrepos.getchatcontact();
  }

  Stream<List<Message>> chatStream(String recieveuserid) {
    return chatrepos.getchatStream(recieveuserid);
  }

  void sendfilemsg({
    required BuildContext context,
    required File file,
    required String receiveruid,
    required Messageenum msgenum,
  }) {
    ref.read(userdataAuthprovider).whenData(
          (value) => chatrepos.sendfilemessage(
            context: context,
            file: file,
            receiveruid: receiveruid,
            senderuserdata: value!,
            ref: ref,
            msgenum: msgenum,
          ),
        );
  }

  void setmessageseen(
      BuildContext context, String recieveuserId, String MessageId) {
    chatrepos.setmessageseen(context, recieveuserId, MessageId);
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/chat/common/enums/msg_enum.dart';
import 'package:dashboard/chat/common/repositories/common_firebase_storgae_repository.dart';
import 'package:dashboard/chat/common/widgets/utility/utils.dart';
import 'package:dashboard/chat/models/chat_contact.dart';
import 'package:dashboard/chat/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user_model.dart';

final chatrepositoryProvider = Provider(
  (ref) => chatrepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class chatrepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  chatrepository({required this.firestore, required this.auth});

//   Stream<List<chatContact>> getchatcontact() {
//   return firestore
//       .collection('users')
//       .doc(auth.currentUser!.uid)
//       .collection('chats')
//       .snapshots()
//       .map((event) async {
//     List<chatContact> contacts = [];
//     for (var document in event.docs) {
//       try {
//         var chatcontact = chatContact.fromMap(document.data());
//         var userData = await firestore
//             .collection('users')
//             .doc(chatcontact.contactid)
//             .get();

//         if (userData.exists) {
//           var user = UserModel.fromMap(userData.data()!);

//           contacts.add(
//             chatContact(
//               name: user.name,
//               profilePic: user.profilePic,
//               contactId: chatContact.contactId,
//               timeSent: chatContact.timeSent,
//               lastMsg: chatContact.lastMsg,
//             ),
//           );
//         } else {
//           // Handle the case where user data doesn't exist
//           // You can log an error or take appropriate action.
//         }
//       } catch (e) {
//         // Handle any exceptions that occur during data retrieval
//         print('Error fetching data: $e');
//       }
//     }
//     return contacts;
//   });
// }

  void setmessageseen(
      BuildContext context, String recieveuserId, String MessageId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieveuserId)
          .collection('messages')
          .doc(MessageId)
          .update({'isseen': true, 'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieveuserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(MessageId)
          .update({'isseen': true, 'isSeen': true});
    } catch (e) {
      showsnackbar(context, 'something Went wrong in Seen');
    }
  }

  Stream<List<chatContact>> getchatcontact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<chatContact> contacts = [];
      for (var document in event.docs) {
        var chatcontact = chatContact.fromMap(document.data());
        var userdata = await firestore
            .collection('users')
            .doc(chatcontact.contactid)
            .get();

        print(userdata);
        var user = UserModel.fromMap(userdata.data()!);
        contacts.add(
          chatContact(
            name: user.name,
            profilepic: user.profilepic,
            contactid: chatcontact.contactid,
            timesent: chatcontact.timesent,
            lastmsg: chatcontact.lastmsg,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getchatStream(String recieveuserid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieveuserid)
        .collection('messages')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
        print(document.data());
      }
      return messages;
    });
  }

  void _savedatatocontactssubcollection(
    UserModel senduserdata,
    UserModel recieveuserdata,
    String Text,
    DateTime timesent,
    String recieveruid,
  ) async {
    var recieverchatContact = chatContact(
      name: senduserdata.name,
      profilepic: senduserdata.profilepic,
      contactid: senduserdata.uid,
      timesent: timesent,
      lastmsg: Text,
    );

    await firestore
        .collection('users')
        .doc(recieveruid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverchatContact.toMap(),
        );

    var senderchatContact = chatContact(
      name: recieveuserdata.name,
      profilepic: recieveuserdata.profilepic,
      contactid: recieveuserdata.uid,
      timesent: timesent,
      lastmsg: Text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieveruid)
        .set(
          senderchatContact.toMap(),
        );
  }

  void _saveMessagetoMessageSubcollection({
    required String recieveruid,
    required String text,
    required DateTime timesent,
    required String messageid,
    required String senderusername,
    required String recieverusername,
    required Messageenum Messagtype,
  }) async {
    final message = Message(
      Senderid: auth.currentUser!.uid,
      recieverid: recieveruid,
      Text: text,
      type: Messagtype,
      timesent: timesent,
      messageid: messageid,
      isseen: false,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieveruid)
        .collection('messages')
        .doc(messageid)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieveruid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageid)
        .set(message.toMap());
  }

  void sendtextmsg({
    required BuildContext context,
    required String text,
    required String recieveruid,
    required UserModel senderuser,
  }) async {
    try {
      var timesent = DateTime.now();
      UserModel reciveruserdata;

      var userdatamap =
          await firestore.collection('users').doc(recieveruid).get();

      reciveruserdata = UserModel.fromMap(userdatamap.data()!);

      var messageid = const Uuid().v4();

      _savedatatocontactssubcollection(
        senderuser,
        reciveruserdata,
        text,
        timesent,
        recieveruid,
      );

      _saveMessagetoMessageSubcollection(
        recieveruid: recieveruid,
        messageid: messageid,
        Messagtype: Messageenum.text,
        timesent: timesent,
        text: text,
        recieverusername: reciveruserdata.name,
        senderusername: senderuser.name,
      );
    } catch (e) {
      showsnackbar(context, e.toString());
      print(e.toString());
    }
  }

  void sendfilemessage({
    required BuildContext context,
    required File file,
    required String receiveruid,
    required UserModel senderuserdata,
    required ProviderRef ref,
    required Messageenum msgenum,
  }) async {
    try {
      var timesent = DateTime.now();
      var messageid = const Uuid().v1();

      String imageurl = await ref
          .read(CommonFirebaseStorageRepositoryprovider)
          .storefiletofirebase(
            'chat/${msgenum.type}/${senderuserdata.uid}/$receiveruid/$messageid',
            file,
          );
      UserModel recieveruserdata;
      var userdatamap =
          await firestore.collection('users').doc(receiveruid).get();
      recieveruserdata = UserModel.fromMap(userdatamap.data()!);

      String contactmsg;

      switch (msgenum) {
        case Messageenum.image:
          contactmsg = '📷Photo';
          break;
        case Messageenum.video:
          contactmsg = '📸Video';
          break;
        case Messageenum.audio:
          contactmsg = '🎵Audio';
          break;

        default:
          contactmsg = 'Something went wrong!';
      }

      _savedatatocontactssubcollection(
        senderuserdata,
        recieveruserdata,
        contactmsg,
        timesent,
        receiveruid,
      );
      _saveMessagetoMessageSubcollection(
        recieveruid: receiveruid,
        text: imageurl,
        timesent: timesent,
        messageid: messageid,
        senderusername: senderuserdata.name,
        recieverusername: recieveruserdata.name,
        Messagtype: msgenum,
      );
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }
}

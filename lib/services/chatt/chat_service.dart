import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/services/chatt/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatService {
  //getv instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    log("iam in chat service");
    return _firestore.collection(usersCollection1).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each indivisual user

        final user = doc.data();

        //retrun user

        return user;
      }).toList();
    });
  }
  //send messages

  Future<void> sendMessages(String recieverID, message) async {
    //get current user info

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        message: message,
        recieverID: recieverID,
        senderEmail: currentUserEmail,
        timestamp: timestamp);

    //construct chat room id for the

    List<String> ids = [currentUserID, recieverID];
    ids.sort();

    String chatRoomID = ids.join('_');
    //add new message to the database

    await _firestore
        .collection(usersCollection)
        .doc(currentUserID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());

    await _firestore
        .collection(usersCollection1)
        .doc(recieverID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get messages

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    log(otherUserID);
    ids.sort();

    log("iam in getMessages");

    String chatRoomID = ids.join('_');

    return _firestore
        .collection(usersCollection)
        .doc(userID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}

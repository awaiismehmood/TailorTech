import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/Customer_views/services/chatt/chat_bubble.dart';
import 'package:dashboard/Customer_views/services/chatt/chat_service.dart';
import 'package:flutter/material.dart';

class chatPage extends StatelessWidget {
  final String recieverEmail;
  final String reciverID;

  chatPage({
    super.key,
    required this.recieverEmail,
    required this.reciverID,
  });

  final TextEditingController _messageController = TextEditingController();

  //chat and auth services

  final chatService _chatService = chatService();

  void sendMessage() async {
    //if there is somethign to send

    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(reciverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("iam in build message list");
    return Scaffold(
      appBar: AppBar(
        title: Text(recieverEmail),
      ),
      body: Column(
        children: [
          //display the messages

          Expanded(
            child: _buildMessageList(),
          ),

          //user input

          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list

  Widget _buildMessageList() {
    log("iam in build message list");
    String senderID = currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, reciverID),
      builder: (context, snapshot) {
        //errors

        if (snapshot.hasError) {
          return Text("Error");
        }

        //loading

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading..");
        }

        //return ListView

        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user

    bool isCurrentUser = data['senderID'] == currentUser!.uid;

    // align message to the right if sender is the current user , otherwise left

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              isCurrentUser: isCurrentUser,
              messages: data['message'],
            ),
          ],
        ));
  }

  //build message input

  Widget _buildUserInput() {
    return Row(
      children: [
        //text field to write message

        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          ),
        ),

        //send button

        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.only(right: 25),
          child: IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_upward,
              color: whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:dashboard/Tailor_views/chat/chat_page%20.dart';
import 'package:dashboard/Tailor_views/chat/chat_service.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/widgets_common/user_tile.dart';
import 'package:flutter/material.dart';

class chatHomeT extends StatelessWidget {
  chatHomeT({super.key});

  final chatServiceT _chatService = chatServiceT();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(currentUser!.uid),
      builder: (context, snapshot) {
        // error

        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading..

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        //return listview

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all user except current
    log("iam in chat home");
    return userTile(
      text: userData["email"],
      ontap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chatPageT(
              recieverEmail: userData["email"],
              reciverID: userData["id"],
            ),
          ),
        );
      }),
    );
  }
}

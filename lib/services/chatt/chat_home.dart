import 'dart:developer';

import 'package:dashboard/services/chatt/chat_page.dart';
import 'package:dashboard/services/chatt/chat_service.dart';
import 'package:dashboard/widgets_common/user_tile.dart';
import 'package:flutter/material.dart';

class chatHome extends StatelessWidget {
  chatHome({super.key});

  final chatService _chatService = chatService();

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
      stream: _chatService.getUserStream(),
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
            builder: (context) => chatPage(
              recieverEmail: userData["email"],
              reciverID: userData["id"],
            ),
          ),
        );
      }),
    );
  }
}

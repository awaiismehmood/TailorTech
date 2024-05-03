import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messages;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.isCurrentUser, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        messages,
        style: TextStyle(
          color: whiteColor,
        ),
      ),
    );
  }
}

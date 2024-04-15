import 'package:dashboard/chat/colors.dart';
import 'package:dashboard/chat/common/enums/msg_enum.dart';
import 'package:dashboard/chat/features/chat/widgets/display_text_file.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final Messageenum msgenum;
  final bool isSeen;

  const MyMessageCard({
    super.key,
    required this.msgenum,
    required this.message,
    required this.date,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 30,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: msgenum == Messageenum.text
                    ? const EdgeInsets.only(
                        left: 5,
                        right: 50,
                        top: 5,
                        bottom: 20,
                      )
                    : const EdgeInsets.only(
                        left: 4,
                        top: 5,
                        right: 5,
                        bottom: 25,
                      ),
                child: Displaytextimagegif(
                  color: messageColor,
                  message: message,
                  messageenum: msgenum,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 18,
                      color: isSeen ? Colors.blue : Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

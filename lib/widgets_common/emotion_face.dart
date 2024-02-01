import 'package:dashboard/consts/colors.dart';
import 'package:flutter/material.dart';

class EmotionFace extends StatelessWidget {
  final String emotionFace;

  const EmotionFace({Key? key, required this.emotionFace}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: redColor, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(
          emotionFace,
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}

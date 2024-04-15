import 'package:dashboard/chat/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String data;
  final VoidCallback onpressesd;

  const CustomButton({
    super.key,
    required this.data,
    required this.onpressesd,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressesd,
      style: ElevatedButton.styleFrom(
          backgroundColor: tabColor,
          minimumSize: const Size(double.infinity, 50)),
      child: Text(
        data,
        style: const TextStyle(
          color: blackcolor,
        ),
      ),
    );
  }
}

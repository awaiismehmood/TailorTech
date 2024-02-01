import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';

class Measurements extends StatelessWidget {
  const Measurements({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Image.asset(
            measure,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

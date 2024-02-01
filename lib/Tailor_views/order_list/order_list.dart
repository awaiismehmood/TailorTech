import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Image.asset(
            orderListt,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

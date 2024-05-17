import 'package:dashboard/consts/colors.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class verifyUser extends StatelessWidget {
  const verifyUser({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Verifyy please!",
                style: TextStyle(fontSize: 100),
              ),
            ),
            TextButton(
                onPressed: () => controller.signoutMethod(context),
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}

import 'package:dashboard/view/auth_screen/login_screen.dart';
import 'package:dashboard/Tailor_views/auth_screen/login_screen.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/try/widget_try.dart';
import 'package:dashboard/widgets_common/applogo_widget.dart';
// import 'package:dashboard/widgets_common/button.dart';
//import 'package:dashboard/widgets_common/applogo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//creating a method to change screen

  /* changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //using get x
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            60.heightBox,
            applogoWidget(),
            //10.heightBox,
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Image.asset(
            //     icSplashBg,
            //     width: 200,
            //   ),
            // ),

            40.heightBox,

            greeting1.text
                .fontFamily(dance)
                .white
                .fontWeight(FontWeight.bold)
                .size(30)
                .make(),
            greeting2.text
                .fontFamily(dance)
                .white
                .fontWeight(FontWeight.bold)
                .size(30)
                .make(),
            // ourButton(
            //         onPress: () {
            //           Get.to(() => const LoginScreen(
            //                 type: "Customer",
            //               ));
            //         },
            //         color: whiteColor,
            //         textcolor: redColor,
            //         tit: "Customer")
            //     .box
            //     .width(context.screenWidth)
            //     .padding(EdgeInsets.symmetric(horizontal: 30))
            //     .make(),

            // 10.heightBox,
            // ourButton(
            //         onPress: () {
            //           Get.to(() => const LoginScreen_Tailor(type: "Tailor"));
            //         },
            //         color: lightGolden,
            //         textcolor: redColor,
            //         tit: "Tailor")
            //     .box
            //     .width(context.screenWidth)
            //     .padding(EdgeInsets.symmetric(horizontal: 30))
            //     .make(),

            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButtonn(
                  tit: "Tailor",
                  tit2: "Welcome aboard! Pleasure to have you on our team!",
                  img: tailor,
                  onPress: () {
                    Get.to(() => const LoginScreen_Tailor(type: "Tailor"));
                  },
                ).box.make(),
                20.widthBox,
                IconButtonn(
                  tit: "Customer",
                  tit2: "Welcome! Honored to serve our valued customers!",
                  img: customer,
                  onPress: () {
                    Get.to(() => const LoginScreen(
                          type: "Customer",
                        ));
                  },
                ),
              ],
            ),
            const Spacer(),
            appversion.text.white.fontFamily(semibold).make(),
            30.heightBox,
            //done here
          ],
        ),
      ),
    );
  }
}

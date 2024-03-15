import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Tailor_views/auth_screen/signup_screen.dart';
import 'package:dashboard/Tailor_views/home_screen/home.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/consts/lists.dart';
import 'package:dashboard/widgets_common/applogo_widget.dart';
import 'package:dashboard/widgets_common/bg_widgets.dart';
import 'package:dashboard/widgets_common/button.dart';
import 'package:dashboard/widgets_common/cuton_textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginScreen_Tailor extends StatefulWidget {
  final String type;
  const LoginScreen_Tailor({required this.type, super.key});

  @override
  State<LoginScreen_Tailor> createState() => _LoginScreenTailorState();
}

class _LoginScreenTailorState extends State<LoginScreen_Tailor> {
  var controller1 = Get.put(AuthController());

//textcontrollers

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.08).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            //2.heightBox,
            "As Tailor".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextField(
                      email, emailHint, controller1.emailController, false),
                  customTextField(password, passwordHint,
                      controller1.passwordController, true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: forgetPass.text.make(),
                    ),
                  ),
                  5.heightBox,
                  controller1.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                              onPress: () async {
                                controller1.isloading(true);

                                await controller1
                                    .loginMethod(context)
                                    .then((value) async {
                                  DocumentSnapshot? userSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection(usersCollection1)
                                          .doc(currentUser!.uid)
                                          .get();
                                  final data = userSnapshot.data()
                                      as Map<String, dynamic>;
                                  final String u_type = data['type'];
                                  if (value != null) {
                                    if (u_type == widget.type) {
                                      VxToast.show(context, msg: logedin);
                                      Get.offAll(() => Home_Tailor());
                                    } else {
                                      setState(() {
                                        controller1.isloading(false);
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      controller1.isloading(false);
                                    });
                                  }
                                });
                              },
                              color: redColor,
                              textcolor: whiteColor,
                              tit: login)
                          .box
                          .width(context.screenWidth)
                          .make(),
                  5.heightBox,
                  create.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                          onPress: () {
                            /*Get.to(() => const SignupScreen_Tailor(
                                  type: widget.type,
                                ));*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignupScreen_Tailor(type: widget.type),
                              ),
                            );
                          },
                          color: lightGolden,
                          textcolor: redColor,
                          tit: signup)
                      .box
                      .width(context.screenWidth)
                      .make(),
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 15,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 30,
                                ),
                              ),
                            )),
                  )
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}

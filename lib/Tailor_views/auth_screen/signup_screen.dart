import 'package:dashboard/Tailor_views/home_screen/home.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widgets.dart';
import '../../widgets_common/button.dart';
import '../../widgets_common/cuton_textfield.dart';
import 'package:get/get.dart';

class SignupScreen_Tailor extends StatefulWidget {
  final String type;
  const SignupScreen_Tailor({required this.type, super.key});

  @override
  State<SignupScreen_Tailor> createState() => _SignupScreenTailorState();
}

class _SignupScreenTailorState extends State<SignupScreen_Tailor> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

//textcontrollers

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwrodController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var phoneController = TextEditingController();
  var cnicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              "AS Tailor".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(name, nameHint, nameController, false),
                    customTextField(email, emailHint, emailController, false),
                    customTextField(
                        password, passwordHint, passwrodController, true),
                    customTextField(retypepass, retypepassHint,
                        passwordRetypeController, true),
                    customTextField(phone, phoneHint, phoneController, false),
                    customTextField(Cnic, cnicHint, cnicController, false),
                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                            checkColor: whiteColor,
                            activeColor: redColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue;
                              });
                            }),
                        5.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey),
                              ),
                              TextSpan(
                                text: terms,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor),
                              ),
                              TextSpan(
                                text: " & ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey),
                              ),
                              TextSpan(
                                text: priacyPol,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor),
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                                onPress: () async {
                                  if (isCheck != false) {
                                    controller.isloading(true);
                                    try {
                                      await controller
                                          .signupMethod(emailController.text,
                                              passwrodController.text, context)
                                          .then((value) {
                                        return controller.storeTailorData(
                                          email: emailController.text,
                                          name: nameController.text,
                                          password: passwrodController.text,
                                          type: widget.type,
                                          phone: phoneController.text,
                                          cnic: cnicController.text,
                                        );
                                      }).then((value) {
                                        VxToast.show(context, msg: logedin);
                                        Get.offAll(() => Home_Tailor());
                                      });
                                    } catch (e) {
                                      auth.signOut();
                                      VxToast.show(context, msg: e.toString());
                                      controller.isloading(false);
                                    }
                                  }
                                },
                                color: isCheck == true ? redColor : lightGrey,
                                textcolor: whiteColor,
                                tit: signup)
                            .box
                            .width(context.screenWidth)
                            .make(),
                    10.heightBox,
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: already,
                            style: TextStyle(fontFamily: bold, color: fontGrey),
                          ),
                          TextSpan(
                            text: login,
                            style: TextStyle(fontFamily: bold, color: redColor),
                          ),
                        ],
                      ),
                    ).onTap(() {
                      Get.back();
                    })
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
      ),
    ));
  }
}

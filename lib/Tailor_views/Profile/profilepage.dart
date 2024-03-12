import 'package:dashboard/Model_Classes/tailor_class.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/consts/lists.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:dashboard/widgets_common/details_button.dart';
import 'package:dashboard/widgets_common/bg_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage_Tailor extends StatefulWidget {
  final Tailor tailor;
  const ProfilePage_Tailor({required this.tailor, super.key});

  @override
  State<ProfilePage_Tailor> createState() => _ProfilePage_TailorState();
}

class _ProfilePage_TailorState extends State<ProfilePage_Tailor> {
  var controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.edit,
                  color: whiteColor,
                ),
              ).onTap(() {}),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  //user details section
                  Image.asset(
                    imgProfile2,
                    width: 85,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                  10.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.tailor.name.text
                            .fontFamily(semibold)
                            .white
                            .make(),
                        5.heightBox,
                        widget.tailor.email.text.white.make(),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                      color: whiteColor,
                    )),
                    onPressed: () =>
                        controller.signoutmethod(context, widget.tailor.type),
                    child: logedout.text.fontFamily(semibold).white.make(),
                  ),
                ],
              ),
            ),
            20.heightBox,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailCard(context.screenWidth / 3.4, "00", "in your cart"),
                detailCard(context.screenWidth / 3.4, "32", "in your wishlist"),
                detailCard(context.screenWidth / 3.4, "675", "your orders"),
              ],
            ),

            // button section

            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return Divider(
                  color: lightGrey,
                );
              },
              itemCount: profileButtonList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.asset(
                    profileButtonsIcon[index],
                    width: 22,
                  ),
                  title: profileButtonList[index]
                      .text
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .make(),
                );
              },
            )
                .box
                .rounded
                .white
                .margin(EdgeInsets.all(12))
                .padding(EdgeInsets.symmetric(horizontal: 16))
                .shadowSm
                .make()
                .box
                .color(redColor)
                .make(),
          ],
        ),
      ),
    ));
  }
}

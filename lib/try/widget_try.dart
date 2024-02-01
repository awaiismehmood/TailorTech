// import 'package:dashboard/consts/colors.dart';

// import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';

Widget IconButtonn({onPress, String? tit, String? tit2, String? img}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      padding: EdgeInsets.symmetric(),
      width: 120,
      height: 300,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 102, 98, 98).withOpacity(0.7),
                offset: Offset(3, 1),
                spreadRadius: 1,
                blurRadius: 5,
                blurStyle: BlurStyle.normal)
          ]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage: AssetImage(img!),
              radius: 58,
            ),
            SizedBox(height: 20.0),
            Text(
              tit!, // Hard-coded text
              style: TextStyle(
                color: redColor,
                fontSize: 18.0,
                fontFamily: bold,
              ),
            ),
            7.heightBox,
            Text(
              tit2!, // Hard-coded text
              style: TextStyle(
                color: redColor,
                fontSize: 10.0,
                fontFamily: semibold,
              ),
              textAlign: TextAlign.center,
            ),
            55.heightBox,
            Icon(
              Icons.check_box_outline_blank_rounded,
              size: 20,
            )
          ]),
    ).box.roundedFull.make(),
  );
}

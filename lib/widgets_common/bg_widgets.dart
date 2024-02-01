import 'package:dashboard/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget bgWidget(Widget? ch) {
  return Container(
    decoration: const BoxDecoration(
      image:
          DecorationImage(image: AssetImage(imgBackground), fit: BoxFit.fill),
    ),
    child: ch,
  );
}

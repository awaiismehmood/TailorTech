import 'package:flutter/cupertino.dart';

import '../consts/consts.dart';

Widget applogoWidget() {
  //using Velocity X
  return Image.asset(T_logo)
      .box
      .color(Color.fromARGB(255, 13, 46, 73))
      .size(77, 77)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}

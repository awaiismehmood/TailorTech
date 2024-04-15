import 'package:dashboard/chat/common/widgets/error.dart';
import 'package:dashboard/chat/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case LoginScreen.routename:
    //   return MaterialPageRoute(
    //     builder: (context) => const LoginScreen(),
    //   );
    // case otpscreen.routename:
    //   final verificationid = settings.arguments as String;

    //   return MaterialPageRoute(
    //     builder: (context) => otpscreen(
    //       verificationid: verificationid,
    //     ),
    //   );
    // case UserinfoScreen.routename:
    //   return MaterialPageRoute(builder: (context) => const UserinfoScreen());
    // case Selectcontactsscreen.routename:
    //   return MaterialPageRoute(
    //       builder: (context) => const Selectcontactsscreen());
    case MobileChatScreen.routename:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];

      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
            body: ErrorScreen(error: 'This Page doesn\'t exist!!')),
      );
  }
}

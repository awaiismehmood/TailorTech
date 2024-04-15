import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/chat/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authrepositoryprovider = Provider((ref) => authrepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class authrepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  authrepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserdata() async {
    var userdata =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    return user;
  }

  // void signinphonenumber(BuildContext context, String phonenum) async {
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phonenum,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //         print('await phonenum');
  //         print(phonenum);
  //       },
  //       verificationFailed: (e) {
  //         throw Exception(e.message.toString());
  //       },
  //       codeSent: ((String verificationId, int? forceResendingToken) async {
  //         Navigator.pushNamed(context, otpscreen.routename,
  //             arguments: verificationId);
  //       }),
  //       codeAutoRetrievalTimeout: ((String verificationId) {}),
  //     );
  //   } catch (e) {
  //     showsnackbar(context, e.toString());
  //     print(e);
  //   }
  // }

  // void verifyotp(
  //     {required BuildContext context,
  //     required String verificationid,
  //     required String userotp}) async {
  //   try {
  //     PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
  //       verificationId: verificationid,
  //       smsCode: userotp,
  //     );
  //     await auth.signInWithCredential(phoneAuthCredential);
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, UserinfoScreen.routename, (route) => false);
  //   } catch (e) {
  //     showsnackbar(context, e.toString());
  //     print(e.toString());
  //   }
  // }

  // void saveuserdatainfirebase(
  //     {required String name,
  //     required File? profilepic,
  //     required ProviderRef ref,
  //     required BuildContext context}) async {
  //   try {
  //     String uid = auth.currentUser!.uid;
  //     String picurl = 'https://cdn-icons-png.flaticon.com/512/2815/2815428.png';
  //     if (profilepic != null) {
  //       picurl = await ref
  //           .read(CommonFirebaseStorageRepositoryprovider)
  //           .storefiletofirebase(
  //             'profilepic/$uid',
  //             profilepic,
  //           );
  //     }
  //     var user = UserModel(
  //       name: name,
  //       uid: uid,
  //       profilepic: picurl,
  //       online: true,
  //       phonenumber: auth.currentUser!.phoneNumber.toString(),
  //       groupid: [],
  //     );

  //     await firestore.collection('users').doc(uid).set(user.toMap());
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
  //       (route) => false,
  //     );
  //   } catch (e) {
  //     showsnackbar(context, 'Something Went Wrong!');
  //     print(e.toString());
  //   }
  // }

  Stream<UserModel> userdata(String userid) {
    return firestore.collection('users').doc(userid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setuserstate(bool isonline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'online': isonline,
    });
  }
}

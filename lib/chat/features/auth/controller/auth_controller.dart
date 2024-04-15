import 'package:dashboard/chat/features/auth/repository/auth_repository.dart';
import 'package:dashboard/chat/models/user_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authcontrollerprovider = Provider((ref) {
  final authrepository = ref.watch(authrepositoryprovider);
  return Authcontroller(authrepos: authrepository, ref: ref);
});
final userdataAuthprovider = FutureProvider((ref) {
  final authcontroller = ref.watch(authcontrollerprovider);
  return authcontroller.getuserdata();
});

class Authcontroller {
  final authrepository authrepos;
  final ProviderRef ref;

  Authcontroller({
    required this.authrepos,
    required this.ref,
  });

  Future<UserModel?> getuserdata() async {
    UserModel? user = await authrepos.getCurrentUserdata();
    return user;
  }

  // void signinwithphone(BuildContext context, String phonenum) {
  //   authrepos.signinphonenumber(context, phonenum);
  // }

  // void verifyotp(BuildContext context, String verificationid, String Userotp) {
  //   authrepos.verifyotp(
  //     context: context,
  //     verificationid: verificationid,
  //     userotp: Userotp,
  //   );
  // }

  // void saveuserdatatofirebase(
  //     BuildContext context, String name, File? profilepic) {
  //   authrepos.saveuserdatainfirebase(
  //       name: name, profilepic: profilepic, ref: ref, context: context);
  // }

  Stream<UserModel> userdatabyid(String UserId) {
    return authrepos.userdata(UserId);
  }

  void setuserstate(bool isonline) {
    authrepos.setuserstate(isonline);
  }
}

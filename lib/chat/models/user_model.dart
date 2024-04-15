class UserModel {
  final String name;
  final String uid;
  final String profilepic;
  final bool online;
  final String phonenumber;
  final List<String> groupid;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilepic,
    required this.online,
    required this.phonenumber,
    required this.groupid,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilepic': profilepic,
      'online': online,
      'phonenumber': phonenumber,
      'groupid': groupid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilepic: map['profilepic'] ?? '',
      online: map['online'] ?? false,
      phonenumber: map['phonenumber'] ?? '',
      groupid: List<String>.from(map['groupid']),
    );
  }
}

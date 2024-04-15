
import 'package:cloud_firestore/cloud_firestore.dart';

class chatContact {
  final String name;
  final String profilepic;
  final String contactid;
  final DateTime timesent;
  final String lastmsg;

  chatContact({
    required this.name,
    required this.profilepic,
    required this.contactid,
    required this.timesent,
    required this.lastmsg,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilepic': profilepic,
      'contactid': contactid,
      'timesent': timesent,
      'lastmsg': lastmsg,
    };
  }

  factory chatContact.fromMap(Map<String, dynamic> map) {
    return chatContact(
      name: map['name']??'',
      profilepic: map['profilepic']??'',
      contactid: map['contactid']??'',
      timesent: (map['timesent'] as Timestamp).toDate(),
      lastmsg: map['lastmsg']??'',
    );
  }
}

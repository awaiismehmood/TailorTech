import 'package:cloud_firestore/cloud_firestore.dart';

class Tailor {
  String name;
  String password;
  String email;
  String type;
  String phone;
  String cnic;
  // double latitude;
  // double longitude;
  String profile_url;

  Tailor({
    required this.name,
    required this.password,
    required this.email,
    required this.type,
    required this.phone,
    required this.cnic,
    required this.profile_url,
    // required this.latitude,
    // required this.longitude,
  });

  factory Tailor.fromFirestore1(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Tailor(
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      cnic: data['CNIC'],
      profile_url: data['ProfileImageurl'],
      type: data['type'] ?? '',
      phone: data['phone'] ?? '',
      // latitude: (data['latitude'] ?? 0).toDouble(),
      // longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }
}

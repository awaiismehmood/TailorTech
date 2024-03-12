import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String name;
  String password;
  String email;
  String type;
  String phone;
  String profileImageUrl;

  Customer({
    required this.name,
    required this.password,
    required this.email,
    required this.type,
    required this.phone,
    required this.profileImageUrl,
  });

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Customer(
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      type: data['type'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['ProfileImageurl'] ?? '',
    );
  }
}

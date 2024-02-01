import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String name;
  String password;
  String email;
  String type;
  String phone;
  double latitude;
  double longitude;

  Customer({
    required this.name,
    required this.password,
    required this.email,
    required this.type,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Customer(
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      type: data['type'] ?? '',
      phone: data['phone'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }
}

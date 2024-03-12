import 'package:dashboard/Tailor_views/order_list/order_history.dart';

/// A placeholder class that represents an entity or model.
class Item {
  const Item({
    required this.id,
    required this.description,
    required this.price,
    required this.quantity,
    required this.status,
  });

  final int id;
  final String description;
  final double price;
  final int quantity;
  final OrderStatus status;
}

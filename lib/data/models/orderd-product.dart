import 'package:evira/controllers/cart-controller.dart';

import './product.dart';

class OrderedProduct extends Product {
  int quantity;

  OrderedProduct({
    required super.gender,
    required super.id,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.maxWeight,
    required super.minWeight,
    required this.quantity,
  });

  factory OrderedProduct.fromJson(Map<dynamic, dynamic> json,
          {int? quantity}) =>
      OrderedProduct(
        gender: json["gender"],
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        price: json["price"],
        maxWeight: json["max_weight"],
        minWeight: json["min_weight"],
        quantity: quantity ?? json["quantity"],
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> superJson = super.toJson();
    superJson['quantity'] = quantity;
    return superJson;
  }

  int getProductQuantity() {
    quantity = CartController.get.getProductQuantity(id.toString());
    return quantity;
  }
}

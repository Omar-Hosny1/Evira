import 'dart:convert';

import 'package:evira/data/models/firebase-models/order.dart';

Map<String, UserOrders> userOrdersFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, UserOrders>(k, UserOrders.fromJson(v)));

String userOrdersToJson(Map<String, UserOrders> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class UserOrders {
  Map<String, Order> orders;
  String email;

  UserOrders({
    required this.orders,
    required this.email,
  });

  factory UserOrders.fromJson(Map<String, dynamic> json) => UserOrders(
        orders: Map.from(json["orders"])
            .map((k, v) => MapEntry<String, Order>(k, Order.fromJson(v))),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "orders": Map.from(orders)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "email": email,
      };
}

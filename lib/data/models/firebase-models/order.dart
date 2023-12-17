import 'package:evira/data/models/orderd-product.dart';

class Order {
  List<OrderedProduct> products;
  String date;
  double totalPrice;

  Order({
    required this.products,
    required this.date,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        products: List<OrderedProduct>.from(
          json["products"].map(
            (x) => OrderedProduct.fromJson(x),
          ),
        ),
        date: json["date"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "date": date,
        "total_price": totalPrice,
      };
}

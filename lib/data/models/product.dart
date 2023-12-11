import 'dart:convert';

import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String gender;
  int id;
  String imageUrl;
  String name;
  int price;
  String weight;

  Product({
    required this.gender,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.weight,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        gender: json["gender"],
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        price: json["price"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "id": id,
        "image_url": imageUrl,
        "name": name,
        "price": price,
        "weight": weight,
      };

  addToCart({void Function()? onDone}) async {
    await CartController.get.addToCart(
      id.toString(),
      onDone: onDone,
    );
  }

  removeFromCart({void Function()? onDone}) async {
    await CartController.get.removeFromCart(
      id.toString(),
      onDone: onDone,
    );
  }

  removeFromCartPermanently({void Function()? onDone}) async {
    await CartController.get.removeFromCartPermanently(
      id.toString(),
      onDone: onDone,
    );
  }

  int getProductQuantity() {
    return CartController.get.getProductQuantity(id.toString());
  }

  removeFromWishlist({void Function()? onDone}) async {
    await WishlistController.get.removeFromWishlist(
      id.toString(),
      onDone: onDone,
    );
  }

  addToWishlist({void Function()? onDone}) async {
    await WishlistController.get.addToWishlist(
      id.toString(),
      onDone: onDone,
    );
  }

  String formatProductName() {
    if (name.length > 14) {
      return '${name.substring(0, 14)}...';
    }
    return name;
  }

  String formatProductPrice() {
    return 'EGP $price';
  }

  String formatProductWeight() {
    return '$weight KG' ;
  }
}

import 'dart:convert';

import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/utils/helpers/handle-loading-state.dart';
import 'package:get/get.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String gender;
  int id;
  String imageUrl;
  String name;
  int price;
  int maxWeight;
  int minWeight;

  final Rx<bool> _isLoadingStateForCart = false.obs;
  final Rx<bool?> _isAddedToCart = Rx(null);

  final Rx<bool> _isLoadingStateForWishlist = false.obs;
  final Rx<bool?> _isAddedToWishlist = Rx(null);

  Rx<bool> get isLoadingStateForCart {
    return Rx(_isLoadingStateForCart.value);
  }

  Rx<bool> get isLoadingStateForWishlist {
    return Rx(_isLoadingStateForWishlist.value);
  }

  Rx<bool?> get isAddedToCart {
    _isAddedToCart.value = _isAddedToCartHelper();
    return Rx(_isAddedToCart.value);
  }

  Rx<bool?> get isAddedToWishlist {
    _isAddedToWishlist.value = _isAddedToTheWishlistHelper();
    return Rx(_isAddedToWishlist.value);
  }

  Product({
    required this.gender,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.maxWeight,
    required this.minWeight,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        gender: json["gender"],
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        price: json["price"],
        maxWeight: json["max_weight"],
        minWeight: json["min_weight"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "id": id,
        "image_url": imageUrl,
        "name": name,
        "price": price,
        "max_weight": maxWeight,
        "min_weight": minWeight,
      };

  Future<void> addToCart() async {
    await handleLoaddingState(
      tryLogic: () async {
        await CartController.get.addToCart(
          id.toString(),
        );
      },
      isLoading: _isLoadingStateForCart,
    );
  }

  Future<void> removeFromCart() async {
    await handleLoaddingState(
      tryLogic: () async {
        await CartController.get.removeFromCart(
          id.toString(),
        );
      },
      isLoading: _isLoadingStateForCart,
    );
  }

  Future<void> removeFromCartPermanently() async {
    await handleLoaddingState(
      tryLogic: () async {
        await CartController.get.removeFromCartPermanently(
          id.toString(),
        );
      },
      isLoading: _isLoadingStateForCart,
    );
  }

  Future<void> removeFromWishlist() async {
    await handleLoaddingState(
      tryLogic: () async {
        await WishlistController.get.removeFromWishlist(
          id.toString(),
        );
      },
      isLoading: _isLoadingStateForWishlist,
    );
  }

  Future<void> addToWishlist() async {
    await handleLoaddingState(
      tryLogic: () async {
        await WishlistController.get.addToWishlist(
          id.toString(),
        );
      },
      isLoading: _isLoadingStateForWishlist,
    );
  }

  String formatProductName({int? subFrom}) {
    subFrom ??= 14;

    if (name.length > subFrom) {
      return '${name.substring(0, subFrom)}...';
    }
    return name;
  }

  String formatProductPrice() {
    return 'EGP $price';
  }

  String formatProductWeight() {
    return '$minWeight-$maxWeight  KG';
  }

  bool? _isAddedToTheWishlistHelper() {
    final currentUserWishlist = WishlistController.get.currentUserWishlist;
    if (currentUserWishlist == null) {
      return null;
    }
    return currentUserWishlist.wishlist[id.toString()] == true;
  }

  bool? _isAddedToCartHelper() {
    final currentUserCart = CartController.get.currentUserCart;
    if (currentUserCart == null) {
      return null;
    }
    return currentUserCart.cart[id.toString()] != null;
  }
}

class UserCart {
  Map<String, int> cart;
  String email;

  UserCart({
    required this.cart,
    required this.email,
  });
  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
        cart: Map.from(json["cart"]).map((k, v) => MapEntry<String, int>(k, v)),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist": Map.from(cart).map((k, v) => MapEntry<String, int>(k, v)),
        "email": email,
      };
}

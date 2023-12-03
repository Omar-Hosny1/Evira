import 'dart:convert';

UserWishlist userWishlistFromJson(String str) =>
    UserWishlist.fromJson(json.decode(str));

String userWishlistToJson(UserWishlist data) => json.encode(data.toJson());

class UserWishlist {
  Map<String, bool> wishlist;
  String email;

  UserWishlist({
    required this.wishlist,
    required this.email,
  });

  factory UserWishlist.fromJson(Map<String, dynamic> json) => UserWishlist(
        wishlist: Map.from(json["wishlist"])
            .map((k, v) => MapEntry<String, bool>(k, v)),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist":
            Map.from(wishlist).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "email": email,
      };
}

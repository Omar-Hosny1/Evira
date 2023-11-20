import 'dart:convert';

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
}

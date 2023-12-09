import 'package:evira/data/models/product.dart';
import 'package:flutter/material.dart';

class WishlistItem extends StatelessWidget {
  final Product product;

  WishlistItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.gender),
        leading: Image.network(product.imageUrl),
        trailing: InkWell(
          onTap: () async {
            await product.removeFromWishlist();
          },
          child: Icon(
            Icons.remove,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

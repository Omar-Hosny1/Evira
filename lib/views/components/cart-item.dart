import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem extends StatelessWidget {
  final Product product;

  CartItem({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final productQuantity =
        CartController.get.currentUserCart!.cart[product.id.toString()]!.obs;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('EGP ${product.price.toStringAsFixed(2)}'),
        leading: CachedNetworkImage(imageUrl: product.imageUrl),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () async {
                await product.decreaseCartProductQuantity();
                productQuantity.value = CartController
                    .get.currentUserCart!.cart[product.id.toString()]!;
              },
            ),
            Obx(() => Text(productQuantity.value.toString())),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await product.increaseCartProductQuantity();
                productQuantity.value = CartController
                    .get.currentUserCart!.cart[product.id.toString()]!;
              },
            ),
          ],
        ),
      ),
    );
  }
}

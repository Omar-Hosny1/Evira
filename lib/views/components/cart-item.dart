import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final _isLoading = false.obs;

  CartItem({
    super.key,
    required this.product,
  });

  void handleAddToCart(RxInt productQuantity) async {
    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await product.addToCart();
      productQuantity.value = product.getProductQuantity();
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  void handleRemoveFromCart(RxInt productQuantity) async {
    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await product.removeFromCart();
      productQuantity.value = product.getProductQuantity();
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productQuantity =
        CartController.get.currentUserCart!.cart[product.id.toString()]!.obs;

    Widget buildProductQuantity() {
      if (_isLoading.isTrue) {
        return FittedBox(child: CircularProgressIndicator());
      }
      return Text(
        productQuantity.value.toString(),
        textAlign: TextAlign.center,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.formatProductPrice()),
        leading: CachedNetworkImage(imageUrl: product.imageUrl),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => IconButton(
                icon: Icon(Icons.remove),
                onPressed: _isLoading.isTrue
                    ? null
                    : () => handleRemoveFromCart(productQuantity),
              ),
            ),
            SizedBox(width: 20, child: Obx(() => buildProductQuantity())),
            Obx(
              () => IconButton(
                icon: Icon(Icons.add),
                onPressed: _isLoading.isTrue
                    ? null
                    : () => handleAddToCart(productQuantity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

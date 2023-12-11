import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWishlistButton extends StatelessWidget {
  const ProductWishlistButton({
    super.key,
    required this.isLoading,
    required this.isFavourite,
    required this.product,
  });

  final RxBool isLoading;
  final Rx<bool?> isFavourite;
  final Product product;

void wishlistIconHandler(Rx<bool?> isFavourite) async {
    if (isFavourite.isTrue == true) {
      await errorHandlerInView(tryLogic: () async {
        isLoading.value = true;
        await product.removeFromWishlist();
        isFavourite.value = false;
      }, finallyLogic: () {
        isLoading.value = false;
      });
      return;
    }
    await errorHandlerInView(tryLogic: () async {
      isLoading.value = true;
      await product.addToWishlist();
      isFavourite.value = true;
    }, finallyLogic: () {
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildIcon() {
      if (isLoading.isTrue == true) {
        return CircularProgressIndicator();
      }

      return Icon(
        isFavourite.isTrue == true
            ? Icons.favorite_rounded
            : Icons.favorite_outline_outlined,
        size: 30,
      );
    }

    return Obx(
      () => IconButton(
        onPressed: isLoading.isTrue ? null : () => wishlistIconHandler(isFavourite),
        icon: buildIcon(),
      ),
    );
  }
}

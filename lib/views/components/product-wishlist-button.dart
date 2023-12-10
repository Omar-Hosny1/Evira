import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWishlistButton extends StatelessWidget {
  const ProductWishlistButton({
    super.key,
    required this.isLoadingStateForFavourite,
    required this.isFavourite,
    required this.product,
  });

  final RxBool isLoadingStateForFavourite;
  final Rx<bool?> isFavourite;
  final Product product;

void wishlistIconHandler(Rx<bool?> isFavourite) async {
    if (isFavourite.isTrue == true) {
      await errorHandlerInView(tryLogic: () async {
        isLoadingStateForFavourite.value = true;
        await product.removeFromWishlist();
        isFavourite.value = false;
      }, finallyLogic: () {
        isLoadingStateForFavourite.value = false;
      });
      return;
    }
    await errorHandlerInView(tryLogic: () async {
      isLoadingStateForFavourite.value = true;
      await product.addToWishlist();
      isFavourite.value = true;
    }, finallyLogic: () {
      isLoadingStateForFavourite.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildIcon() {
      if (isLoadingStateForFavourite.isTrue == true) {
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
        onPressed: () => wishlistIconHandler(isFavourite),
        icon: buildIcon(),
      ),
    );
  }
}

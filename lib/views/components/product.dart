import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/views/components/product-cart-button.dart';
import 'package:evira/views/components/product-wishlist-button.dart';
import 'package:evira/views/screens/product-details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product.dart';

bool? _isFavouriteHelper(String productId) {
  final currentUserWishlist = WishlistController.get.currentUserWishlist;
  if (currentUserWishlist == null) {
    return null;
  }
  return currentUserWishlist.wishlist[productId] == true;
}

bool? isAddedToCartHelper(String productId) {
  final currentUserCart = CartController.get.currentUserCart;
  if (currentUserCart == null) {
    return null;
  }
  return currentUserCart.cart[productId] != null;
}

class ProductView extends StatelessWidget {
  final Product product;
  final RxBool _isLoadingStateForFavourite = false.obs;
  final RxBool _isLoadingStateForCart = false.obs;

  ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final Rx<bool?> isFavourite = Rx(_isFavouriteHelper(product.id.toString()));
    final Rx<bool?> isAddedToCart = Rx(
      isAddedToCartHelper(product.id.toString()),
    );

    return InkWell(
      onTap: () {
        Get.toNamed(ProductDetails.routeName, arguments: product.id);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: ProductWishlistButton(
                    isLoadingStateForFavourite: _isLoadingStateForFavourite,
                    isFavourite: isFavourite,
                    product: product,
                  ),
                )
              ],
            ),
            Text(
              product.formatProductName(),
              style: const TextStyle(),
              textAlign: TextAlign.center,
            ),
            Text(product.formatProductPrice()),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ProductCartButton(
                isAddedToCart: isAddedToCart,
                isLoadingStateForCart: _isLoadingStateForCart,
                product: product,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

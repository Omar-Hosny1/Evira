import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/screens/product-details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product.dart';


 bool? isFavouriteHelper(String productId) {
    final wishlistController = WishlistController.get.currentUserWishlist;
    if (wishlistController == null) {
      return null;
    }
    print('************* isFavouriteHelper RAN *****************');
    return wishlistController.wishlist[productId] == true;
  }

  bool? isAddedToCartHelper(String productId) {
    final currentUserCart = CartController.get.currentUserCart;
    if (currentUserCart == null) {
      print('************** currentUserCart is null ***************');
      print(currentUserCart);
      return null;
    }
    return currentUserCart.cart[productId] != null;
  }

// ignore: must_be_immutable
class ProductView extends StatelessWidget {
  final Product product;

  ProductView({
    super.key,
    required this.product,
    // required this.isFavourite,
    // required this.isAddedToCart,
  });

  @override
  Widget build(BuildContext context) {
  final Rx<bool?> isFavourite = Rx(isFavouriteHelper(product.id.toString()));
  final Rx<bool?> isAddedToCart = Rx(isAddedToCartHelper(product.id.toString()));
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
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: InkWell(
                    onTap: () async {
                      if (isFavourite.isTrue == true) {
                        await WishlistController.get.removeFromWishlist(
                            product.id.toString(), onDone: () {
                          isFavourite.value = false;
                        });
                        return;
                      }
                      await WishlistController.get.addToWishlist(
                          product.id.toString(),
                          onDone: () => isFavourite.value = true);
                    },
                    child: Obx(
                      () => Icon(
                        isFavourite.isTrue == true
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              product.name.length > 20
                  ? '${product.name.substring(0, 17)}...'
                  : product.name,
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            Text("${product.price} EGP"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Obx(
                () => BaseButton(
                  buttonStyle: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    backgroundColor: isAddedToCart.isTrue == true
                        ? Colors.transparent
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(
                          color: Colors.black,
                        )),
                  ),
                  textStyle: TextStyle(
                    color: isAddedToCart.isTrue == true
                        ? Colors.black
                        : Colors.white,
                  ),
                  text: isAddedToCart.isTrue == true
                      ? 'Remove Cart'
                      : 'Add To Cart',
                  onPressed: () async {
                    if (isAddedToCart.isTrue == true) {
                      await CartController.get
                          .removeFromCart(product.id.toString(), onDone: () {
                        isAddedToCart.value = false;
                      });
                      return;
                    }
                    await CartController.get.addToCart(product.id.toString(),
                        onDone: () {
                      isAddedToCart.value = true;
                    });
                  },
                  // child: Text(

                  //     style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/data/data-sources/wishlist-ds.dart';
import 'package:evira/views/screens/product-details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product.dart';

class ProductView extends StatelessWidget {
  final Product product;
  final bool isFavourite;
  const ProductView(
      {super.key, required this.product, required this.isFavourite});

  @override
  Widget build(BuildContext context) {
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
                  child: Image.network(
                    product.imageUrl,
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: InkWell(
                    onTap: () {
                      if (isFavourite == true) {
                        WishlistController.get
                            .removeFromWishlist(product.id.toString());
                        return;
                      }
                      WishlistController.get
                          .addToWishlist(product.id.toString());
                    },
                    child: Icon(
                      isFavourite == true
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_outlined,
                      size: 30,
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
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                onPressed: () {},
                child: Text('Cart', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

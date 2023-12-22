import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/views/components/home/product-cart-button.dart';
import 'package:evira/views/components/home/product-wishlist-button.dart';
import 'package:evira/views/screens/product-details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product.dart';

class ProductView extends StatelessWidget {
  final Product product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: product.isLoadingStateForCart.isTrue ||
                product.isLoadingStateForWishlist.isTrue
            ? null
            : () {
                Get.toNamed(ProductDetails.routeName, arguments: product);
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
                  product: product,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

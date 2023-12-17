import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/cart-btn-handler.dart';
import 'package:evira/views/components/wishlist-btn-handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimens.vertical_padding,
              horizontal: Dimens.horizontal_padding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Center(
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
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name'),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Text(product.name),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price'),
                        Text(product.formatProductPrice())
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight'),
                        Text(product.formatProductWeight())
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CartBtnHandler(product: product),
                SizedBox(
                  height: 10,
                ),
                WishlistBtnHandler(product: product),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

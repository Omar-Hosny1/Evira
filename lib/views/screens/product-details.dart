import 'package:evira/controllers/products-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});
  static final routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int;
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.vertical_padding,
          horizontal: Dimens.horizontal_padding,
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: ProductController.get.getProduct(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('LOADING');
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Text(snapshot.data?.gender ?? 'N/A');
              },
            ),
          ],
        ),
      ),
    ));
  }
}

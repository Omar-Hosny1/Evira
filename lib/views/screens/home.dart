import 'package:evira/controllers/products-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/logo.dart';
import 'package:evira/views/components/product.dart';
import 'package:evira/views/components/toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.horizontal_padding,
              vertical: Dimens.vertical_padding),
          child: Column(
            children: [
              Logo(),
             Toggle(),
              GetBuilder<ProductController>(
                id: Strings.productsGetBuilderId,
                builder: (controller) => Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 10,
                        childAspectRatio: 4 / 7),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      return ProductView(product: controller.products[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

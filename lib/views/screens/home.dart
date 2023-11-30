import 'package:evira/controllers/auth-controller.dart';
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
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                onTap: (){
                  // AuthController.get.();
                },
                title: const Text(
                  'Logout'
                ),
              ),
              ListTile(
                onTap: (){
                  AuthController.get.logOut();
                },
                title: const Text(
                  'Logout'
                ),
              ),
              ListTile(
                title: const Text(
                  'Add Blog',
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
          title: Logo(),
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: Dimens.horizontal_padding,
              right: Dimens.horizontal_padding,
              bottom: Dimens.vertical_padding),
          child: Column(
            children: [
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

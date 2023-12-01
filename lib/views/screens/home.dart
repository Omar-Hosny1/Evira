import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
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
              Obx(
                () => ListTile(
                  onTap: () {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', "e.toString()");
                    // AuthController.get.();
                  },
                  title: Text(AuthController.get.userData?.getName ?? 'N/A'),
                ),
              ),
              ListTile(
                onTap: () {
                  AuthController.get.logOut();
                },
                title: const Text('Logout'),
              ),
              ListTile(
                onTap: () {
                  AuthController.get.logOut();
                },
                title: const Text('Logout'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
          title: const Logo(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Toggle(),
              Expanded(
                child: GetBuilder<ProductController>(
                  id: Strings.productsGetBuilderId,
                  builder: (controller) => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 10,
                      childAspectRatio: 4 / 7,
                    ),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) => ProductView(
                      product: controller.products[index],
                    ),
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

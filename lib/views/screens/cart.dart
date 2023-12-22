import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import 'package:evira/views/components/cart/cart-bottom-bar.dart';
import 'package:evira/views/components/cart/cart-container.dart';
import 'package:evira/views/components/common/main-drawer.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  Cart({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        bottomNavigationBar: CartBottomBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.horizontal_padding,
            vertical: Dimens.vertical_padding,
          ),
          child: FutureBuilder(
            future: CartController.get.getUserCart(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError == true) {
                return Center(
                  child: Text(
                    formatErrorMessage(
                      snapshot.error.toString(),
                    ),
                  ),
                );
              }
              return const CartContainer();
            },
          ),
        ),
      ),
    );
  }
}

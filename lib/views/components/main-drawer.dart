import 'package:evira/data/data-sources/order-ds.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/views/components/user-list-tile.dart';
import 'package:evira/views/screens/cart.dart';
import 'package:evira/views/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserListTile(),
          // ListTile(
          //   onTap: () async{
          //     // await ProductDS().raiseProduct();
          //   },
          //   title: const Text('Raise Data'),
          // ),
          ListTile(
            onTap: () async {
              await OrderDS().addOrder(
                'hosnyomar022@gmail.com',
                [
                  Product(
                    gender: 'gender',
                    id: 5,
                    imageUrl: 'imageUrl',
                    name: 'name',
                    price: 55,
                    weight: 'weight',
                  ),
                  Product(
                    gender: 'gender',
                    id: 5,
                    imageUrl: 'imageUrl',
                    name: 'name',
                    price: 55,
                    weight: 'weight',
                  ),
                ],
                1500,
              );
            },
            title: const Text('Upload Order'),
          ),
          ListTile(
            onTap: () {
              Get.back(closeOverlays: true);
              Get.toNamed(Wishlist.routeName);
            },
            title: const Text('Wishlist'),
          ),
          ListTile(
            onTap: () {
              Get.back(closeOverlays: true);
              Get.toNamed(Cart.routeName);
            },
            title: const Text('Cart'),
          ),
        ],
      ),
    );
  }
}

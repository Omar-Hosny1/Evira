import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/views/components/user-list-tile.dart';
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
          ListTile(
            onTap: () {
              AuthController.get.logOut();
            },
            title: const Text('Logout'),
          ),
          ListTile(
            onTap: () {
              Get.back(closeOverlays: true);
              Get.toNamed(Wishlist.routeName);
            },
            title: const Text('Wishlist'),
          ),
        ],
      ),
    );
  }
}

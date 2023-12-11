import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class UserListTile extends StatelessWidget {
  UserListTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Short-circuiting is a useful feature as it can optimize code execution by avoiding unnecessary evaluations when the outcome is already determined based on the first operand.

    return GetBuilder<AuthController>(
      id: Strings.userListTileGetBuilderId,
      builder: (controller) => controller.userData == null
          ? const ListTile(
              title: Text('N/A', style: TextStyle(fontSize: 18)),
            )
          : Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: ListTile(
                trailing: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: controller.userData!.getImagePath!,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back(closeOverlays: true);
                  Get.toNamed(Profile.routeName);
                },
                subtitle: Text(
                  controller.userData!.getEmail!,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                title: Text(
                  controller.userData!.getName!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
    );
  }
}

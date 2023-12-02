import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/constants/strings.dart';
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
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    controller.userData!.getImagePath!,
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                  ),
                ),
                onTap: () {},
                subtitle: Text(controller.userData!.getEmail!,
                    style: const TextStyle(fontSize: 12)),
                title: Text(controller.userData!.getName!,
                    style: const TextStyle(fontSize: 18)),
              ),
            ),
    );
  }
}

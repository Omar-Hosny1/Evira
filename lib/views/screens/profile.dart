import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/common/back-arrow.dart';
import 'package:evira/views/components/profile/delete-account-card.dart';
import 'package:evira/views/screens/update-user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackArrow(),
          title: Text('Your Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            top: Dimens.vertical_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GetBuilder<AuthController>(
                          id: Strings.userListenersGetBuilderId,
                          builder: (controller) => InkWell(
                            onTap: () {
                              Get.bottomSheet(Container(
                                margin: EdgeInsets.all(20),
                                child: CachedNetworkImage(
                                  imageUrl: controller.userData!.getImagePath!,
                                ),
                              ));
                            },
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: CachedNetworkImageProvider(
                                controller.userData!.getImagePath!,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        GetBuilder<AuthController>(
                          id: Strings.userListenersGetBuilderId,
                          builder: (controller) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userData!.getName!,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                controller.userData!.getEmail!,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    GetBuilder<AuthController>(
                      id: Strings.userListenersGetBuilderId,
                      builder: (controller) => Card(
                        child: ListTile(
                          trailing:
                              Text(controller.userData!.getAge!.toString()),
                          leading: Icon(Icons.person),
                          title: Text('Your Age'),
                        ),
                      ),
                    ),
                    GetBuilder<AuthController>(
                      id: Strings.userListenersGetBuilderId,
                      builder: (controller) => Card(
                        child: ListTile(
                          trailing:
                              Text(controller.userData!.getHeight!.toString()),
                          leading: Icon(Icons.height),
                          title: Text('Your Height'),
                        ),
                      ),
                    ),
                    GetBuilder<AuthController>(
                      id: Strings.userListenersGetBuilderId,
                      builder: (controller) => Card(
                        child: ListTile(
                          trailing: Text(
                            controller.userData!.getWeight!.toString(),
                          ),
                          leading: Icon(Icons.monitor_weight),
                          title: Text('Your Weight'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(UpdateUser.routeName);
                        },
                        trailing: Icon(Icons.arrow_forward),
                        leading: Icon(Icons.person),
                        title: Text('Update Your Data'),
                      ),
                    ),
                    DeleteAccountCard(),
                    Card(
                      child: ListTile(
                        onTap: () async {
                          Get.defaultDialog(
                            titlePadding: EdgeInsets.only(top: 20),
                            title: 'Logout Confirmation',
                            middleText: 'Are You Sure That You Want To Logout?',
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AuthController.get.logOut();
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.red,
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

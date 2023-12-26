import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountCard extends StatelessWidget {
  DeleteAccountCard({super.key});
  final _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          Get.defaultDialog(
            titlePadding: EdgeInsets.only(top: 20),
            title: 'Account Deletion Confirmation',
            middleText: 'Are You Sure That You Want To Delete Your Account?',
            onWillPop: () async {
              return _isLoading.value == false;
            },
            actions: [
              TextButton(
                onPressed: () {
                  if (_isLoading.isTrue == true) {
                    return;
                  }
                  Get.back();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await errorHandlerInView(tryLogic: () async {
                    _isLoading.value = true;
                    await AuthController.get.deleteAccount();
                  }, finallyLogic: () {
                    _isLoading.value = false;
                  });
                },
                child: Obx(
                  () => Text(
                    _isLoading.isTrue ? 'Loading...' : 'Delete My Account',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        leading: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        title: Text(
          'Delete My Account',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

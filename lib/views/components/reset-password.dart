import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:evira/utils/validations/common-validations.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/base/base-input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  TextEditingController _controller = TextEditingController();
  final _isLoading = false.obs;

  void _submit() async {
    final enteredText = _controller.text;
    final isHasValidationErrors = validateEmail(enteredText);
    if (isHasValidationErrors != null) {
      showSnackbar(
        SnackbarState.danger,
        'Validation Error',
        isHasValidationErrors,
      );
      return;
    }

    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await AuthController.get.resetPassword(enteredText);
      Get.back(closeOverlays: true);
      showSnackbar(
        SnackbarState.success,
        'Check Your Email...',
        'Email Sent Successfuly',
      );
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 180,
        padding: EdgeInsets.all(10),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            BaseInput(
              label: 'Email',
              controller: _controller,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => SizedBox(
                  width: double.infinity,
                  child: BaseButton(
                    onPressed: _isLoading.isTrue ? null : _submit,
                    text: _isLoading.isTrue ? 'Loading...' : 'Send Now',
                    textStyle: TextStyle(color: Colors.white),
                    buttonStyle: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 22)),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

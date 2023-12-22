import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/utils/validations/common-validations.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/base/base-input.dart';
import 'package:evira/views/components/profile/reset-password.dart';
import 'package:evira/views/screens/auth/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  SignIn({super.key});
  static const routeName = '/sign-in';
  String _enteredPassword = '';
  String _enteredEmail = '';

  final _isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();

  _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != true) {
      return;
    }

    _formKey.currentState?.save();
    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await AuthController.get.signIn(_enteredEmail, _enteredPassword);
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: Dimens.horizontal_padding,
              right: Dimens.horizontal_padding,
              bottom: Dimens.vertical_padding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Sign in To Evira Now...',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.start,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  BaseInput(
                    onSaved: (v) {
                      _enteredEmail = v!;
                    },
                    label: 'Email',
                    validator: validateEmail,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v) {
                      _enteredPassword = v!;
                    },
                    label: 'Password',
                    isPassword: true,
                    validator: validatePassword,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => SizedBox(
                        width: double.infinity,
                        child: BaseButton(
                          onPressed: _isLoading.isTrue ? null : _submit,
                          text: _isLoading.isTrue ? 'Loading...' : 'Sign In',
                          textStyle: TextStyle(color: Colors.white),
                          buttonStyle: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 25)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BaseButton(
                      text: 'Sign Up',
                      onPressed: () {
                        Get.offNamed(SignUp.routeName);
                      },
                      textStyle: TextStyle(color: Colors.black),
                      buttonStyle: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 25)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.bottomSheet(ResetPassword());
                    },
                    child: Text('Forgot Your Password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

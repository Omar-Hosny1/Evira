import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/validations/common.dart';
import 'package:evira/utils/validations/sign-up.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/base/base-input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  static const routeName = '/';
  // static const routeName = '/sign-up';

  final _formKey = GlobalKey<FormState>();
  final  User _enteredUserData = User();
  
  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid != true) {
      return;
    }
    _formKey.currentState?.save();
    final authController = Get.find<AuthController>();
    print(_enteredUserData.getUserData());
    authController.signUp(_enteredUserData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: SingleChildScrollView(
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
                        'Sign Up To Evira Now...',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.start,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  BaseInput(
                    label: 'Name',
                    onSaved: (v){
                      _enteredUserData.name = v!;
                    },
                    validator: validateName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v){
                      _enteredUserData.email = v!;
                    },
                    label: 'Email',
                    validator: validateEmail,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v){
                      _enteredUserData.password = v!;
                    },
                    label: 'Password',
                    isPassword: true,
                    validator: validatePassword,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v){
                      _enteredUserData.age = int.parse(v!);
                    },
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    validator: validateAge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    keyboardType: TextInputType.number,
                    onSaved: (v){
                      _enteredUserData.weight = int.parse(v!);
                    },
                    label: 'Weight (KG)',
                    validator: validateWeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v){
                      _enteredUserData.height = int.parse(v!);
                    },
                    keyboardType: TextInputType.number,
                    label: 'Height (CM)',
                    validator: validateHeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: BaseButton(
                        onPressed: _submit,
                        text: 'Sign Up',
                        textStyle: TextStyle(color: Colors.white),
                        buttonStyle: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 25)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: BaseButton(
                        text: 'Sign In',
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
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

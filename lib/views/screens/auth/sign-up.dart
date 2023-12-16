import 'dart:async';
import 'dart:io';

import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/device/device_utils.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/utils/validations/common-validations.dart';
import 'package:evira/utils/validations/sign-up-validations.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/base/base-input.dart';
import 'package:evira/views/components/base/drop-down.dart';
import 'package:evira/views/screens/auth/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({super.key});
  static const routeName = '/sign-up';

  // form validation
  final Rx<XFile?> _photo = Rx(null);

  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  final User _enteredUserData = User();

  final Rx<String> _photoErrMsg = ''.obs;
  final _isLoading = false.obs;

  void _submit() async {
    final isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }
    if (_photo.value == null) {
      _photoErrMsg.value = 'Please Pick up an profile image';
      return;
    }
    if (_enteredUserData.getGender == null) {
      _enteredUserData.gender = Strings.gendersArray[0].toLowerCase();
    }

    _photoErrMsg.value = '';
    _enteredUserData.image = File(_photo.value!.path);

    _formKey.currentState?.save();
    final authController = Get.find<AuthController>();

    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await authController.signUp(_enteredUserData);
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _photo.value = pickedFile;
    if (pickedFile != null) {
      _photoErrMsg.value = '';
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    _photo.value = pickedFile;
    if (pickedFile != null) {
      _photoErrMsg.value = '';
    }
  }

  void _showPicker() {
    DeviceUtils.hideKeyboard();
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Get.back(closeOverlays: true);
                  imgFromGallery();
                }),
            ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Get.back(closeOverlays: true);
                  imgFromCamera();
                }),
          ],
        ),
      ),
      isDismissible: true,
    );
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
                    keyboardType: TextInputType.name,
                    onSaved: (v) {
                      _enteredUserData.name = v!;
                    },
                    validator: validateName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v) {
                      _enteredUserData.email = v!;
                    },
                    label: 'Email',
                    validator: validateEmail,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v) {
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
                    onSaved: (v) {
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
                    onSaved: (v) {
                      _enteredUserData.weight = int.parse(v!);
                    },
                    label: 'Weight (KG)',
                    validator: validateWeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    onSaved: (v) {
                      _enteredUserData.height = int.parse(v!);
                    },
                    keyboardType: TextInputType.number,
                    label: 'Height (CM)',
                    validator: validateHeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropDown(
                      dropDownItems: Strings.gendersArray,
                      onChange: (val) {
                        _enteredUserData.gender = val.toLowerCase();
                        print(val);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BaseButton(
                      onPressed: _showPicker,
                      text: 'Pick Up a Profile Image',
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
                  Obx(
                    () {
                      if (_photo.value == null) {
                        return const SizedBox();
                      }

                      return TextButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                child: Image.file(File(_photo.value!.path)),
                              ),
                            );
                          },
                          child: Text('See The Selected Image'));
                    },
                  ),
                  Obx(
                    () {
                      if (_photoErrMsg.value == '') {
                        return SizedBox(
                          height: 10,
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(_photoErrMsg.value),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    },
                  ),
                  Obx(
                    () => SizedBox(
                        width: double.infinity,
                        child: BaseButton(
                          onPressed: _isLoading.isTrue ? null : _submit,
                          text: _isLoading.isTrue ? 'Loading...' : 'Sign Up',
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
                      text: 'Sign In',
                      onPressed: () {
                        Get.offNamed(SignIn.routeName);
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

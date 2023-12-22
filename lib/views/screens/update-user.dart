import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/device/device_utils.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:evira/utils/validations/sign-up-validations.dart';
import 'package:evira/views/components/common/back-arrow.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/base/base-input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUser extends StatelessWidget {
  UpdateUser({super.key});
  static const routeName = '/update-user';
  final _formKey = GlobalKey<FormState>();

  final Rx<XFile?> _photo = Rx(null);
  final ImagePicker _picker = ImagePicker();
  final _isLoading = false.obs;
  final Rx<bool> _isFromDirty = false.obs;
  final authController = AuthController.get;
  final userData = AuthController.get.userData!;

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != true) {
      return;
    }
    if (_isFromDirty.isFalse && _photo.value == null) {
      showSnackbar(
        SnackbarState.danger,
        'No Data Changed Yet',
        'Try To Edit what you want',
      );
      return;
    }

    if (_photo.value != null) {
      userData.image = File(_photo.value!.path);
    }
    _formKey.currentState?.save();

    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await authController.updateUserData(userData);
      Get.back();
      showSnackbar(
        SnackbarState.success,
        'Updated Successfluy',
        'Your Data Updated Successfuly',
      );
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _photo.value = pickedFile;
  }

  Future<void> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    _photo.value = pickedFile;
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
                  Get.back();
                  imgFromGallery();
                }),
            ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Get.back();
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
        appBar: AppBar(
          title: Text('Update Your Data'),
          leading: BackArrow(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.horizontal_padding,
            vertical: Dimens.vertical_padding,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: InkWell(
                      onTap: _showPicker,
                      child: Obx(
                        () => CircleAvatar(
                          backgroundImage: _photo.value == null
                              ? CachedNetworkImageProvider(
                                  userData.getImagePath!,
                                  scale: 150,
                                )
                              : FileImage(
                                  File(
                                    _photo.value!.path,
                                  ),
                                ) as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    label: 'Name',
                    initialValue: userData.getName,
                    keyboardType: TextInputType.name,
                    onSaved: (v) {
                      userData.name = v!;
                    },
                    onChanged: (_) {
                      _isFromDirty.value = true;
                    },
                    validator: validateName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    initialValue: userData.getAge.toString(),
                    onSaved: (v) {
                      userData.age = int.parse(v!);
                    },
                    onChanged: (_) {
                      _isFromDirty.value = true;
                    },
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    validator: validateAge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    initialValue: userData.getWeight.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (v) {
                      userData.weight = int.parse(v!);
                    },
                    onChanged: (_) {
                      _isFromDirty.value = true;
                    },
                    label: 'Weight (KG)',
                    validator: validateWeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BaseInput(
                    initialValue: userData.getHeight.toString(),
                    onSaved: (v) {
                      userData.height = int.parse(v!);
                    },
                    onChanged: (_) {
                      _isFromDirty.value = true;
                    },
                    keyboardType: TextInputType.number,
                    label: 'Height (CM)',
                    validator: validateHeight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: BaseButton(
                        onPressed: _isLoading.isTrue ||
                                (_isFromDirty.value == false &&
                                    _photo.value == null)
                            ? null
                            : _submit,
                        text: _isLoading.isTrue ? 'Loading...' : 'Update',
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
                      ),
                    ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserController extends GetxController {
  static UpdateUserController get get => Get.find();

  late TextEditingController _nameEditingController;
  late TextEditingController _ageEditingController;
  late TextEditingController _weightEditingController;
  late TextEditingController _heightEditingController;
  final Rx<bool?> _isFromDirty = Rx(null);

  Rx<bool?> getIsFromDirty({
    required String currentName,
    required String currentAge,
    required String currentWeight,
    required String currentHeight,
  }) {
    _isFromDirtyHelper(
      currentName: currentName,
      currentAge: currentAge,
      currentWeight: currentWeight,
      currentHeight: currentHeight,
    );
    return Rx(_isFromDirty.value);
  }

  @override
  void onInit() {
    _nameEditingController = TextEditingController();
    _ageEditingController = TextEditingController();
    _weightEditingController = TextEditingController();
    _heightEditingController = TextEditingController();
    super.onInit();
  }

  setFieldsInitialValue({
    required String name,
    required String age,
    required String weight,
    required String height,
  }) {
    _nameEditingController.text = name;
    _weightEditingController.text = weight;
    _heightEditingController.text = height;
    _ageEditingController.text = age;
  }

  void _isFromDirtyHelper({
    required String currentName,
    required String currentAge,
    required String currentWeight,
    required String currentHeight,
  }) {
    if (_nameEditingController.text != currentName ||
        _ageEditingController.text != currentAge ||
        _weightEditingController.text != currentWeight ||
        _heightEditingController.text != currentHeight) {
      _isFromDirty.value = true;
      return;
    }
    _isFromDirty.value = false;
  }

  @override
  void onClose() {
    _nameEditingController.dispose();
    _ageEditingController.dispose();
    _weightEditingController.dispose();
    _heightEditingController.dispose();
    super.onClose();
  }
}

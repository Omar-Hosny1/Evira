import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarState { danger, success, wait }

_getSnackbarStateColor(SnackbarState snackbarState) {
  switch (snackbarState) {
    case SnackbarState.success:
      return Colors.green;
    case SnackbarState.wait:
      return Colors.yellow;
    case SnackbarState.danger:
      return Colors.red;
    default:
      return Colors.green;
  }
}

showSnackbar(SnackbarState snackbarState, String title, String subTitle) {
  Get.snackbar(
    title,
    subTitle,
    colorText:
        snackbarState == SnackbarState.wait ? Colors.black : Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: 10,
    icon: const Icon(Icons.message, color: Colors.white),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(seconds: 5),
    backgroundColor: _getSnackbarStateColor(snackbarState),
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(15),
  );
}

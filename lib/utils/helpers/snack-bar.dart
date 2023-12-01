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
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    backgroundColor: _getSnackbarStateColor(snackbarState),
    margin: const EdgeInsets.all(5),
  );
}
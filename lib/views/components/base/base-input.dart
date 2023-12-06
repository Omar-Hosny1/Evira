import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseInput extends StatelessWidget {
  BaseInput({
    super.key,
    this.validator,
    this.label,
    this.isPassword,
    this.onSaved,
    this.keyboardType,
    this.controller,
  });

  final String? Function(String?)? validator;
  final String? label;
  final bool? isPassword;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  final showPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    if (isPassword == true) {
      return Obx(
        () => TextFormField(
          controller: controller,
          onSaved: onSaved,
          validator: validator,
          cursorColor: Colors.white,
          keyboardType: keyboardType,
          obscureText: isPassword == true ? showPassword.value : false,
          decoration: InputDecoration(
            suffixIcon: isPassword == true
                ? Obx(
                    () => InkWell(
                      onTap: () {
                        showPassword.value = !showPassword.value;
                      },
                      child: Icon(
                        showPassword.value == false
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
                      ),
                    ),
                  )
                : null,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
            hintText: label,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
          ),
        ),
      );
    }
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
      validator: validator,
      cursorColor: Colors.white,
      keyboardType: keyboardType,
      obscureText: isPassword == true ? showPassword.value : false,
      decoration: InputDecoration(
        suffixIcon: isPassword == true
            ? Obx(
                () => InkWell(
                  onTap: () {
                    showPassword.value = !showPassword.value;
                  },
                  child: Icon(
                    showPassword.value == false
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye,
                  ),
                ),
              )
            : null,
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        hintText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
      ),
    );
  }
}

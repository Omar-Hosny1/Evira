import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.text,
    this.buttonStyle,
    this.textStyle,
    this.onPressed,
    this.horizontalPadding = 15,
    this.verticalPadding = 17,
  });
  final void Function()? onPressed;
  final String text;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding!,
              horizontal: horizontalPadding!,
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

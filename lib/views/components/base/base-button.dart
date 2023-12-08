import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key, required this.text, this.buttonStyle, this.textStyle, this.onPressed});
  final void Function()? onPressed;
  final String text;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 17,horizontal: 15),
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

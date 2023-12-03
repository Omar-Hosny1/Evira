import 'package:evira/utils/constants/dimens.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
          bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}

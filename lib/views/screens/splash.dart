import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  static const routeName = '/splash';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

import 'package:evira/utils/binding/app-binding.dart';
import 'package:evira/utils/constants/app_theme.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.themeData(
        AppThemeData.lightColorScheme,
        Color(0xFF1F1929),
      ),
      initialBinding: AppBinding(),
      getPages: Routes.routes,
    );
  }
}

import 'package:evira/utils/binding/app-binding.dart';
import 'package:evira/utils/constants/app_theme.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/routes/routes.dart';
import 'package:evira/views/screens/splash.dart';
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
        Color.fromARGB(0, 121, 82, 184),
      ),
      initialBinding: AppBinding(),
      initialRoute: Splash.routeName,
      getPages: Routes.routes,
    );
  }
}

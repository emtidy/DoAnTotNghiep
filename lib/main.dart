import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/model/pages/layout/layout.dart';
import 'package:coffee_cap/model/pages/screens/home/home_screen.dart';
import 'package:coffee_cap/model/pages/screens/sign_In/sign_in.dart';
import 'package:coffee_cap/model/pages/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/assets.dart';
import 'core/colors/color.dart';
import 'core/themes/theme_data.dart';
import 'firebase_options.dart';
import 'model/Menu_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  // final menuService = MenuService();
  //  await menuService.uploadDefaultData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyAppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignIn(),
        '/home': (context) => const AppLayout(),
      },
    );
  }
}

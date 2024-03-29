import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nuestra_historia/controller/auth_controller.dart';
import 'package:nuestra_historia/fcm/firebase_api.dart';
import 'package:nuestra_historia/firebase_options.dart';
import 'package:nuestra_historia/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  Get.put(AuthController());
  await GetStorage.init();

  runApp(const GetMaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [Locale('es', 'ES')],
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ktg_news_app/views/homepage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'custom_animation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black87
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.black
    //..maskColor = Colors.black.withOpacity(2)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kênh Tin Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme( // <-- SEE HERE
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: HomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true; // ⚠️ dev only
    return client;
  }
}

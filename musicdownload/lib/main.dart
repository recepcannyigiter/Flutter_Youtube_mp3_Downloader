// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';


import 'package:musicdownload/shared/constant.dart';
import 'env_config/routes.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await FlutterDownloader.initialize(
        debug: false // optional: set false to disable printing logs to console
    );
  }
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ücretsiz mp3 indir",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kDarkBlueColor,
      ),
      initialRoute: "/home",
      getPages: AppRoutes.ROUTES,
    ),
  );
}
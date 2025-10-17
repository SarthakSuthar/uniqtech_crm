import 'package:crm/app_const/theme/app_theme.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/login/controller/login_controller.dart';
import 'package:crm/services/local_db.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/services/shred_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Ensure Flutter is ready before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefHelper.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    // For web platforms, use the ffi database factory
    databaseFactory = databaseFactoryFfiWeb;
  }

  // 2. Initialize the database (this will trigger _onCreate if it's the first time).
  // We don't need to store the result, just ensure it's been called.
  await DatabaseHelper().database;
  AppUtils.showlog("Database Initialized!");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
      initialBinding: AuthBinding(),
    );
  }
}

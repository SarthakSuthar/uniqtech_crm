import 'package:crm/app_const/theme/app_theme.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/model/contact_model.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/login/controller/login_controller.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
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
  showlog("Database Initialized!");

  // --- Example Usage of your Repo ---
  // Create a dummy contact
  var newContact = ContactModel(
    uid: 'dummy-uid-123',
    custName: 'Dummy Customer Inc.',
    address: '123 Main St',
    city: 'Anytown',
    state: 'Anystate',
    district: 'Anydistrict',
    country: 'USA',
    pincode: '12345',
    mobileNo: '1234567890',
    email: 'dummy@example.com',
    website: 'www.dummy.com',
    businessType: 'Software',
    industryType: 'IT',
    status: 'Active',
    contactName: 'John Doe',
    department: 'Sales',
    designation: 'Manager',
    contEmail: 'john.doe@example.com',
    contMobileNo: '0987654321',
    contPhoneNo: '555-1234',
  );

  // Insert it using the repo
  await ContactsRepo.insertContact(newContact);
  showlog("Dummy contact inserted.");

  var uom = UomModel(name: "uom", code: "123");

  await UomRepo.insertUom(uom);
  showlog("Dummy uom inserted.");

  var product = ProductModel(
    productCode: "1234",
    productName: "prod",
    productUom: "uom",
    productRate: "123",
    productDescription: "desc",
  );

  await ProductRepo.addProduct(product);
  showlog("Dummy product inserted.");

  // ------------------------------------

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

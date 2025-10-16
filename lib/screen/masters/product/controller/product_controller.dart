import 'dart:convert';
import 'dart:io';

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/login/repo/user_repo.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  RxString? selectedUom = RxString("");

  final List<String> fields = [
    "product_name",
    "product_code",
    "product_uom",
    "product_rate",
    "product_description",
    "product_image",
    "product_document",
  ];

  void updateUom(String? value) {
    if (value != null) selectedUom?.value = value;
  }

  @override
  void onInit() async {
    super.onInit();
    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
    await getProducts();
    await getUomList();
    await loadUserId();
  }

  String? uid;

  Future<void> loadUserId() async {
    try {
      uid = await UserRepo.getUserId();
      AppUtils.showlog("uid in customer controller : $uid");
    } catch (e) {
      AppUtils.showlog("error in customer controller : $e");
    }
  }

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    super.onClose();
  }

  Future<void> addProduct() async {
    try {
      uid ??= await UserRepo.getUserId();
      final result = await ProductRepo.addProduct(
        ProductModel(
          productName: controllers["product_name"]!.text,
          productCode: controllers["product_code"]!.text,
          productRate: controllers["product_rate"]!.text,
          productUom: selectedUom?.value,
          productDescription: controllers["product_description"]!.text,
          productImage: controllers["product_image"]!.text,
          productDocument: controllers["product_document"]!.text,
          createdBy: uid,
          updatedBy: uid,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        ),
      );
      AppUtils.showlog("Added Product ---> $result");
      AppUtils.showlog("Product Added Successfully");
      Get.back();
    } catch (e) {
      AppUtils.showlog("Error adding product: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  RxList<ProductModel> products = <ProductModel>[].obs;

  Future<void> getProducts() async {
    try {
      final result = await ProductRepo.getAllProducts();
      AppUtils.showlog("Got Products List ---> ${result.length}");
      AppUtils.showlog("all products ---> ${jsonEncode(result)}");
      products.value = result;
    } catch (e) {
      AppUtils.showlog("error getting products: $e");
    }
  }

  var uomList = <UomModel>[].obs;

  Future<void> getUomList() async {
    try {
      final result = await UomRepo.getAllUom();
      uomList.assignAll(result);
      AppUtils.showlog("uom list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      AppUtils.showlog("Error getting UOM list : $e");
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final result = await ProductRepo.getProductById(id);
      AppUtils.showlog("Got Product ---> ${result.toJson()}");
      return result;
    } catch (e) {
      AppUtils.showlog("error getting product by id: $e");
      rethrow;
    }
  }

  // ----------- File Selection ----------
  final RxList<File> selectedFiles = <File>[].obs;
  final RxList<File> selectedImages = <File>[].obs;

  Future<void> selectFiles() async {
    try {
      // Open File Picker (allow both docs & images)
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          // Common mobile document formats
          'pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt',
          // Common image formats
          'jpg', 'jpeg', 'png', 'heic', 'webp',
        ],
      );

      if (result == null) return;

      final file = File(result.files.single.path!);
      final ext = file.path.split('.').last.toLowerCase();

      // Define allowed document and image extensions
      const docExtensions = [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'txt',
      ];
      const imageExtensions = ['jpg', 'jpeg', 'png', 'heic', 'webp'];

      if (docExtensions.contains(ext)) {
        selectedFiles.add(file);
        controllers["product_document"]?.text = file.path;
        AppUtils.showlog("📄 Selected document: ${file.path}");
      } else if (imageExtensions.contains(ext)) {
        selectedImages.add(file);
        controllers["product_image"]?.text = file.path;
        AppUtils.showlog("🖼️ Selected image: ${file.path}");
      } else {
        showErrorSnackBar("Unsupported file type: .$ext");
      }
    } catch (e) {
      AppUtils.showlog("❌ Error selecting files: $e");
    }
  }
}

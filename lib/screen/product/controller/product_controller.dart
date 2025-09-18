import 'dart:convert';
import 'dart:io';

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/product/model/product_model.dart';
import 'package:crm/screen/product/repo/product_repo.dart';
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
  }

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    super.onClose();
  }

  Future<void> addProduct() async {
    try {
      final result = await ProductRepo.addProduct(
        ProductModel(
          productName: controllers["product_name"]!.text,
          productCode: controllers["product_code"]!.text,
          productRate: controllers["product_rate"]!.text,
          productUom: selectedUom?.value,
          productDescription: controllers["product_description"]!.text,
          productImage: controllers["product_image"]!.text,
          productDocument: controllers["product_document"]!.text,
        ),
      );
      showlog("Added Product ---> $result");
      showlog("Product Added Successfully");
      Get.back();
    } catch (e) {
      showlog("Error adding product: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  RxList<ProductModel> products = <ProductModel>[].obs;

  Future<void> getProducts() async {
    try {
      final result = await ProductRepo.getAllProducts();
      showlog("Got Products List ---> ${result.length}");
      showlog("all products ---> ${jsonEncode(result)}");
      products.value = result;
    } catch (e) {
      showlog("error getting products: $e");
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final result = await ProductRepo.getProductById(id);
      showlog("Got Product ---> ${result.toJson()}");
      return result;
    } catch (e) {
      showlog("error getting product by id: $e");
      rethrow;
    }
  }

  // ----------- File Selection ----------
  RxList selectedFiles = [].obs; // New list to store selected files
  RxList selectedImages = [].obs; // New list to store selected images

  Future<void> selectFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        // type: FileType.custom,
        // allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        if (file.path.endsWith('.pdf') ||
            file.path.endsWith('.word') ||
            file.path.endsWith('.excel')) {
          selectedFiles.add(file);
          controllers["product_document"]!.text = file.path;
          showlog("Selected file: ${file.path}");
        } else {
          selectedImages.add(file);
          controllers["product_image"]!.text = file.path;
          showlog("Selected image: ${file.path}");
        }
      }
    } catch (e) {
      showlog("Error selecting files: $e");
    }
  }
}

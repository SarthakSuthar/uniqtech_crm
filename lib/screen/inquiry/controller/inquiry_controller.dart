import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiryController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  // Dropdown values
  RxString? selectedProduct = RxString("");
  RxString? selectedUOM = RxString("");

  final List<String> fields = [
    "num",
    "date",
    "name1",
    "name2",
    "email",
    "mobile",
    "social",
    "quntity",
    "rate",
    "amount",
    "remarks",
  ];

  @override
  void onInit() {
    super.onInit();
    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
  }

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    super.onClose();
  }

  void updateProduct(String? val) {
    if (val != null) selectedProduct?.value = val;
  }

  void updateUOM(String? val) {
    if (val != null) selectedUOM?.value = val;
  }
}

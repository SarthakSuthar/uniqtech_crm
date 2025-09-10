import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotesController extends GetxController {
  RxString? selectedProduct = "".obs;
  RxString? selectedUOM = "".obs;

  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};

  @override
  void onInit() {
    super.onInit();
    _initializeControllersAndFocusNodes();
  }

  void _initializeControllersAndFocusNodes() {
    final fields = [
      "num",
      "date",
      "name1",
      "name2",
      "email",
      "mobile",
      "social",
      "quntity",
      "discount",
      "rate",
      "amount",
      "remarks",
      "termAndCondition",
    ];

    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
  }

  void updateProduct(String? value) {
    selectedProduct?.value = value ?? "";
  }

  void updateUOM(String? value) {
    selectedUOM?.value = value ?? "";
  }

  @override
  void onClose() {
    _disposeControllersAndFocusNodes();
    super.onClose();
  }

  void _disposeControllersAndFocusNodes() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
  }
}

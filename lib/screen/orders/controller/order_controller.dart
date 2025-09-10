import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  RxString? selectedProduct = RxString("");
  RxString? selectedUOM = RxString("");

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

  void updateProduct(String? val) {
    if (val != null) selectedProduct?.value = val;
  }

  void updateUOM(String? val) {
    if (val != null) selectedUOM?.value = val;
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

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TasksController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  RxString selectedTypeOfWork = ''.obs;
  RxString noSearchController = ''.obs;

  RxList typeOfWorkList = ["1", "2", "3"].obs;

  final List<String> fields = [
    "no",
    "noSearch",
    "date",
    "taskDiscription",
    "assignedTo",
    "image",
    "attached",
    "work",
    "workType",
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

  void updateTypeOfWork(String? newValue) {
    if (newValue != null) {
      selectedTypeOfWork.value = newValue;
    }
  }
}

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UomController extends GetxController {
  RxList<UomModel> allUoms = <UomModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllUoms();
  }

  @override
  void onClose() {
    uomNameController.dispose();
    uomCodeController.dispose();
    super.onClose();
  }

  final TextEditingController uomNameController = TextEditingController();
  final TextEditingController uomCodeController = TextEditingController();

  final FocusNode uomNameFocusNode = FocusNode();
  final FocusNode uomCodeFocusNode = FocusNode();

  /// Get all UOMs
  Future<void> getAllUoms() async {
    try {
      isLoading.value = true;
      List<UomModel> uoms = await UomRepo.getAllUom();
      allUoms.assignAll(uoms);
    } catch (e) {
      showlog('Error fetching UOMs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Insert a new UOM
  Future<void> insertUom() async {
    try {
      isLoading.value = true;
      UomModel uom = UomModel(
        name: uomNameController.text,
        code: uomCodeController.text,
      );
      int result = await UomRepo.insertUom(uom);
      showlog("uom insert result : $result");
      getAllUoms();
    } catch (e) {
      showlog('Error inserting UOM: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ///delete UOM
  Future<void> deleteUom(int id) async {
    try {
      isLoading.value = true;
      await UomRepo.deleteUom(id);
      showlog("deleted uom id : $id");
      getAllUoms();
    } catch (e) {
      showlog('Error deleting UOM: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

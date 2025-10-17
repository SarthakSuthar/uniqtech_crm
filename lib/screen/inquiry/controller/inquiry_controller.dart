import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/inquiry/model/inquiry_followup_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_product_model.dart';
import 'package:crm/screen/inquiry/repo/inquiry_repo.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:crm/screen/quotes/model/quotation_followup_model.dart';
import 'package:crm/screen/quotes/model/quotation_model.dart';
import 'package:crm/screen/quotes/model/quotation_product_model.dart';
import 'package:crm/screen/quotes/repo/quotation_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InquiryController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  bool isEdit = false;
  String? no;

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
    "quantity",
    "rate",
    "amount",
    "remarks",
    "followupDate",
    "followupType",
    "followupStatus",
    "followupRemarks",
    "followupAssignedTo",
  ];

  final dateFormat = DateFormat("d/M/yyyy");

  @override
  void onInit() async {
    super.onInit();
    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
    await getInquiryList();
    await getProductList();
    await getinquiryProductList();
    await getCustomersList();
    await getUomList();
    await getUid();

    // Set initial inquiry number based on the total number of inquiries
    if (isEdit == true) {
      await setEditDetails();
    } else {
      //get last id from table
      controllers['num']!.text = (await InquiryRepo().getNextInquiryId())
          .toString();

      // controllers['num']!.text = (inquiryList.length + 1).toString();
      controllers['date']!.text = dateFormat.format(DateTime.now());
    }
  }

  Future<void> setEditDetails() async {
    int intNo = int.parse(no ?? '');

    controllers['num']!.text = no!;
    controllers['date']!.text = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .date!;
    controllers['name1']!.text = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    selectedCustomer.value = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    controllers['email']!.text = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .email!;
    controllers['mobile']!.text = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .mobileNo!;
    controllers['social']!.text = inquiryList
        .firstWhereOrNull((element) => element.id == intNo)!
        .source!;

    if (no != null) {
      await getinquiryProductList();
    }
  }

  // @override
  // void onClose() {
  //   controllers.forEach((_, controller) => controller.dispose());
  //   focusNodes.forEach((_, node) => node.dispose());
  //   super.onClose();
  // }

  // @override
  // void dispose() {
  //   controllers.forEach((_, controller) => controller.dispose());
  //   focusNodes.forEach((_, node) => node.dispose());
  //   selectedCustomer.value = '';
  //   selectedProduct?.value = '';
  //   selectedUOM?.value = '';
  //   super.dispose();
  // }

  void calculateAmount() {
    final quntityText = controllers["quantity"]!.text;
    final rateText = controllers["rate"]!.text;

    if (quntityText.isNotEmpty && rateText.isNotEmpty) {
      final quntity = double.tryParse(quntityText) ?? 0.0;
      final rate = double.tryParse(rateText) ?? 0.0;
      final amount = quntity * rate;
      controllers["amount"]!.text = amount.toStringAsFixed(2);
    } else {
      controllers["amount"]!.text = "";
    }
  }

  ///update selected product according to edit or not
  void updateProduct(String? val) {
    if (val != null) {
      selectedProduct?.value = val;
      // Set UOM according to the selected product from the product list
      final product = productList.firstWhereOrNull((p) => p.productName == val);
      if (product != null &&
          product.productUom != null &&
          product.productRate != null) {
        selectedUOM?.value = product.productUom!;
        controllers["rate"]!.text = product.productRate!;
        calculateAmount();
      }
    }
  }

  void updateUOM(String? val) {
    if (val != null) selectedUOM?.value = val;
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

  final RxList<InquiryModel> inquiryList = <InquiryModel>[].obs;
  final RxList<InquiryModel> filterendList = <InquiryModel>[].obs;

  /// Search for customer name or number
  void searchResult(String val) {
    AppUtils.showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = inquiryList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = inquiryList.where((item) {
      final custName = item.custName1?.toLowerCase();
      final uid = item.id?.toString().toLowerCase();

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid?.contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  // -------- Lists for dropdown and selections -------

  /// get inquiry list
  Future<void> getInquiryList() async {
    try {
      final result = await InquiryRepo.getAllInquiries();
      inquiryList.assignAll(result);
      filterendList.value = inquiryList;
      AppUtils.showlog(
        "inquiry list : ${result.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      AppUtils.showlog("error on get inquiry list : $e");
    }
  }

  var productList = <ProductModel>[].obs;

  ///get all product list
  Future<void> getProductList() async {
    try {
      final result = await ProductRepo.getAllProducts();
      productList.assignAll(result);
    } catch (e) {
      AppUtils.showlog("error on get product list : $e");
    }
  }

  RxList<InquiryProductModel> inquiryProductList = <InquiryProductModel>[].obs;

  /// get inquiry product list
  Future<void> getinquiryProductList() async {
    try {
      final result = await InquiryRepo.getAllInquiryProducts();
      AppUtils.showlog(
        "getinquiryProductList result : ${result.map((e) => e.toJson()).toList()}",
      );

      final numText = controllers['num']?.text ?? "";
      AppUtils.showlog("controllers['num']?.text --> $numText");
      final inquiryId = int.tryParse(numText);

      if (inquiryId == null) {
        AppUtils.showlog("Invalid inquiryId: $numText");
        inquiryProductList.clear();
        return;
      } else {
        AppUtils.showlog("inquiryId : $inquiryId");
      }

      inquiryProductList.assignAll(
        result.where((element) => element.inquiryId == inquiryId).toList(),
      );
      AppUtils.showlog(
        "inquiry product list : ${inquiryProductList.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      AppUtils.showlog("error on get inquiry product list : $e");
    }
  }

  var customerList = <String, String>{}.obs;
  var selectedCustomer = "".obs;

  /// get customers list
  Future<void> getCustomersList() async {
    try {
      final result = await ContactsRepo.getAllContacts();
      //map name to id
      for (var contact in result) {
        customerList[contact.custName!] = contact.id.toString();
      }
      customerList.forEach(
        (key, value) => AppUtils.showlog("Customer list $key : $value"),
      );
    } catch (e) {
      AppUtils.showlog("error on get customers list : $e");
    }
  }

  /// get user details by id
  Future<void> getSelectedContactDetails(String name) async {
    try {
      AppUtils.showlog("name --> $name");
      final id = customerList[name] ?? '';
      AppUtils.showlog("get user details by id --> $id");

      final result = await ContactsRepo.getContactById(id);
      controllers["email"]?.text = result.email!;
      controllers["mobile"]?.text = result.mobileNo!;
      AppUtils.showlog("selected contact details : ${result.toJson()}");
    } catch (e) {
      AppUtils.showlog("error on get user details : $e");
    }
  }

  // ------------------------

  ///add Customer
  Future<void> addInquiryCustomer() async {
    try {
      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      AppUtils.showlog("custName : $custName");
      AppUtils.showlog("custId : $custId");

      final inquiryCustomer = InquiryModel(
        createdBy: await AppUtils.uid,
        updatedBy: await AppUtils.uid,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        // custName2: controllers["name2"]!.text,
        date: controllers["date"]!.text,
        email: controllers["email"]!.text,
        mobileNo: controllers["mobile"]!.text,
        source: controllers["social"]!.text,
      );

      AppUtils.showlog(
        "added inquiry customer ----> ${inquiryCustomer.toJson()}",
      );

      int result = await InquiryRepo.insertInquiry(inquiryCustomer);
      AppUtils.showlog("insert inquiry customer ----> $result");
      // showSuccessSnackBar("Customer added successfully");
      await getInquiryList();
    } catch (e) {
      showErrorSnackBar("Error adding customer");
      AppUtils.showlog("error on add customer : $e");
    }
  }

  /// Retrive product id of selected product
  int getProductId(String productName) {
    try {
      final product = productList.firstWhereOrNull(
        (p) => p.productName == productName,
      );
      return product?.productId ?? 0;
    } catch (e) {
      AppUtils.showlog("Error getting product id : $e");
      rethrow;
    }
  }

  //create temp list, display it in ui
  //when new product addede by "ADD" button, add that to temp
  // on save button press save it to db

  RxList<InquiryProductModel> tempProductList = <InquiryProductModel>[].obs;

  String? uid;

  Future<void> getUid() async {
    try {
      uid = await AppUtils.uid;
    } catch (e) {
      AppUtils.showlog("Error getting uid : $e");
    }
  }

  void addtempProductList() {
    final inquiryId = int.parse(controllers['num']!.text);

    AppUtils.showlog("Inquiry Id in addInquiryProductID : $inquiryId");

    try {
      tempProductList.add(
        InquiryProductModel(
          inquiryId: inquiryId,
          createdBy: uid,
          updatedBy: uid,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          productId: getProductId(selectedProduct!.value),
          quantity: int.parse(controllers["quantity"]!.text),
          remark: controllers["remarks"]!.text,
        ),
      );

      inquiryProductList.addAll(tempProductList);
      showSuccessSnackBar("Product added successfully");
    } catch (e) {
      showErrorSnackBar("Error adding product");
      AppUtils.showlog("Error adding product : $e");
    }
  }

  ///add inquiry & product id to table so we have track of for a customer how many products inquiry we have
  /*Future<void> addInquiryProductID() async {
    try {
      final inquiryId = int.parse(controllers['num']!.text);

      AppUtils.showlog("Inquiry Id in addInquiryProductID : $inquiryId");

      final inqProdId = InquiryProductModel(
        inquiryId: inquiryId,
        productId: getProductId(selectedProduct!.value),
        quantity: int.parse(controllers["quantity"]!.text),
        remark: controllers["remarks"]!.text,
      );

      AppUtils.showlog("inquiry id : ${inqProdId.inquiryId}");
      AppUtils.showlog("product id : ${inqProdId.productId}");

      int result = await InquiryRepo.insertInquiryProduct(inqProdId);
      showSuccessSnackBar("Product added successfully");
      AppUtils.showlog("insert inquiry product ----> $result");
      await getinquiryProductList();
    } catch (e) {
      showErrorSnackBar("Error adding Product");
      AppUtils.showlog("Error adding product & inquiry ID : $e");
    }
  }*/

  Future<void> addInquiryProductID() async {
    try {
      for (var element in tempProductList) {
        int result = await InquiryRepo.insertInquiryProduct(element);
        // showSuccessSnackBar("Product added successfully");
        AppUtils.showlog("insert inquiry product ----> $result");
        await getinquiryProductList();
      }
    } catch (e) {
      showErrorSnackBar("Error adding Product");
      AppUtils.showlog("Error adding product & inquiry ID : $e");
    }
  }

  Future<void> deleteInquiryProduct({required int id}) async {
    //  implement delete logic
  }

  Future<int> updateInquiryProductID() async {
    try {
      if (tempProductList != inquiryProductList) {
        for (var element in tempProductList) {
          int result = await InquiryRepo.insertInquiryProduct(element);
          AppUtils.showlog("update inquiry product ----> $result");
          await getinquiryProductList();
          return result;
        }
      } else {
        AppUtils.showlog("tempProductList == inquiryProductList");
      }
      return 0;
    } catch (e) {
      AppUtils.showlog("Error updating product : $e");
      return 0;
    }
  }

  ///save inquiry
  Future<void> submitInquiry() async {
    try {
      await addInquiryCustomer(); // customer
      await addInquiryProductID();
      await getInquiryList();
      // Get.back(result: true);
      Get.offAndToNamed(AppRoutes.dashboard);
      showSuccessSnackBar("Inquiry submitted successfully");
    } catch (e) {
      AppUtils.showlog("Error submitting inquiry : $e");
    }
  }

  Future<void> deleteInquiry({required int id}) async {
    try {
      await InquiryRepo.deleteInquiry(id);
      await getInquiryList();
      await InquiryRepo.deleteInquiryProduct(id);
      await InquiryRepo.deleteInquiryFollowup(id);
      showSuccessSnackBar("Inquiry deleted successfully");
      await getinquiryProductList();
    } catch (e) {
      showErrorSnackBar("Error deleting inquiry");
      AppUtils.showlog("Error deleting inquiry : $e");
    }
  }

  // ----------------------- UPDATE --------------------------

  //1. need to update on id -- pars controllers vlue
  //update selected product list
  //update followup

  Future<void> updateInquiry() async {
    try {
      // update customer details

      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      AppUtils.showlog("custName : $custName");
      AppUtils.showlog("custId : $custId");

      int inquiryId = int.parse(controllers['num']!.text);
      AppUtils.showlog("inquiryId : $inquiryId");
      final inquiry = InquiryModel(
        id: inquiryId,
        updatedBy: await AppUtils.uid,
        updatedAt: DateTime.now().toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        // custName2: "controllers['name2']!.text",
        date: controllers['date']!.text,
        email: controllers['email']!.text,
        mobileNo: controllers['mobile']!.text,
        source: controllers['social']!.text,
      );
      AppUtils.showlog("updated inquiry ----> ${inquiry.toJson()}");

      // update product list

      int result = await InquiryRepo.updateInquiry(inquiry);
      AppUtils.showlog("update inquiry ----> $result");

      //update product list

      int updateProduct = await updateInquiryProductID();
      AppUtils.showlog("ipdated product --> $updateProduct");
      showSuccessSnackBar("Inquiry updated successfully");
    } catch (e) {
      showErrorSnackBar("Error updating inquiry");
      AppUtils.showlog("Error update inquiry : $e");
    }
  }

  // MARK: Inquiry Follow up

  final selectedFollowupDate = "".obs;
  final selectedFollowupType = "".obs;
  final selectedFollowupStatus = "".obs;
  final selectedFollowupRemarks = "".obs;
  final selectedFollowupAssignedTo = "".obs;

  RxList<InquiryFollowupModel> inquiryFollowupList =
      <InquiryFollowupModel>[].obs;

  RxList<InquiryFollowupModel> tempInquiryFollowupList =
      <InquiryFollowupModel>[].obs;

  ///GET SELECTED Followup DETAIL's
  Future<void> setSelectedFollowupDetail(int selectedFolloupId) async {
    try {
      final result = await InquiryRepo.getInquiryFollowupById(
        selectedFolloupId,
      );
      AppUtils.showlog("selected followup detail : ${result.toJson()}");
      selectedFollowupAssignedTo.value = result.followupAssignedTo!;
      selectedFollowupDate.value = result.followupDate;
      selectedFollowupRemarks.value = result.followupRemarks!;
      selectedFollowupStatus.value = result.followupStatus!;
      selectedFollowupType.value = result.followupStatus!;
    } catch (e) {
      AppUtils.showlog("Error getting selected followup detail : $e");
    }
  }

  ///GET FOLLOWUP LIST
  ///
  ///return only selected inquiry assigned followups
  Future<List<InquiryFollowupModel>> getInquiryFollowupList(
    int inquiryId,
  ) async {
    try {
      final result = await InquiryRepo.getInquiryFollowupListByInquiryId(
        inquiryId,
      );
      inquiryFollowupList.assignAll(result);
      AppUtils.showlog(
        "inquiry followup list : ${result.map((e) => e.toJson()).toList()}",
      );
      return result;
    } catch (e) {
      AppUtils.showlog("Error getting inquiry followup list : $e");
      return [];
    }
  }

  ///ADD FOLLOWUP
  Future<void> addInquiryFollowup(String inquiryId) async {
    try {
      int intId = int.parse(inquiryId);

      final inquiryFollowup = InquiryFollowupModel(
        inquiryId: intId,
        createdBy: await AppUtils.uid,
        updatedBy: await AppUtils.uid,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        followupDate: controllers['followupDate']!.text,
        followupStatus: selectedFollowupStatus.value,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: selectedFollowupAssignedTo.value,
      );
      AppUtils.showlog(
        "added inquiry followup ----> ${inquiryFollowup.toJson()}",
      );
      int result = await InquiryRepo.insertInquiryFollowup(inquiryFollowup);
      await getInquiryFollowupList(intId);
      showSuccessSnackBar("Followup added successfully");
      AppUtils.showlog("insert inquiry followup ----> $result");
    } catch (e) {
      showErrorSnackBar("Error adding inquiry followup");
      AppUtils.showlog("Error adding inquiry followup : $e");
    }
  }

  RxBool followupSelected = false.obs;

  ///UPDATE FOLLOWUP
  Future<void> updateInquiryFollowup(String inquiryId) async {
    try {
      int intId = int.parse(inquiryId);
      AppUtils.showlog("intId : $intId");

      final inquiryFollowup = InquiryFollowupModel(
        id: intId,
        inquiryId: intId,
        updatedBy: await AppUtils.uid,
        updatedAt: DateTime.now().toString(),
        followupDate: controllers['followupDate']!.text,
        followupStatus: selectedFollowupStatus.value,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: selectedFollowupAssignedTo.value,
      );

      AppUtils.showlog(
        "updated inquiry followup ----> ${inquiryFollowup.toJson()}",
      );
      int result = await InquiryRepo.updateInquiryFollowup(inquiryFollowup);
      showSuccessSnackBar("Followup updated successfully");
      AppUtils.showlog("update inquiry followup ----> $result");
    } catch (e) {
      showErrorSnackBar("Error updating inquiry followup");
      AppUtils.showlog("Error update inquiry followup : $e");
    }
  }

  // --------------------------------------------------------------------
  //MARK: Convert to Quotation

  ///Steps
  /// 1. get inquiry customer from [table] and add it to quotation table
  /// 2. on complethin of step 1 -> add data from product table into quotation product table
  /// 3. on completion of step 2 -> take data from inquiry followup table and add it to quotation followup table
  ///

  int newQuotationId = 0;

  Future<void> convertInquiryToQuotation({required String inquiryId}) async {
    try {
      // get inquiry data and build Model objects

      // pars them into method calls below

      //get inquiry by id
      //create model
      //call convertInquiryCustomerToQuotationCustomer

      ////convertInquiryCustomerToQuotationCustomer
      final customerInquiry = await InquiryRepo.getInquiryById(inquiryId);
      AppUtils.showlog("customerInquiry : ${customerInquiry.toJson()}");
      await convertInquiryCustomerToQuotationCustomer(customerInquiry);

      //get product list for selected inquiry
      //parse list into convertInquiryProductToQuotationProduct

      final inquiryProductList = await InquiryRepo.getAllInquiryProducts();

      final selectedInquiryProductList = inquiryProductList
          .where((element) => element.inquiryId == int.parse(inquiryId))
          .toList();
      AppUtils.showlog(
        "inquiryProductList : ${selectedInquiryProductList.map((e) => e.toJson()).toList()}",
      );
      await convertInquiryProductToQuotationProduct(inquiryProductList);

      //get followup list for selected inquiry

      final inquiryFollowupList = await InquiryRepo.getAllInquiryFollowups();

      final selectedInquiryFollowupList = inquiryFollowupList
          .where((element) => element.inquiryId == int.parse(inquiryId))
          .toList();
      AppUtils.showlog(
        "inquiryFollowupList : ${selectedInquiryFollowupList.map((e) => e.toJson()).toList()}",
      );
      await convertInquiryFollowupToQuotationFollowup(
        selectedInquiryFollowupList,
      );

      showSuccessSnackBar("Inquiry converted to quotation successfully");
    } catch (e) {
      showErrorSnackBar("Error converting inquiry to quotation");
      AppUtils.showlog("Error converting inquiry to quotation: $e");
    }
  }

  //convert inq customer to quotation customer
  Future<void> convertInquiryCustomerToQuotationCustomer(
    InquiryModel inquiry,
  ) async {
    try {
      final quotation = QuotationModel(
        createdBy: inquiry.createdBy,
        updatedBy: inquiry.updatedBy,
        createdAt: inquiry.createdAt,
        updatedAt: inquiry.updatedAt,
        custId: inquiry.custId,
        custName1: inquiry.custName1,
        // custName2: inquiry.custName2,
        date: inquiry.date,
        email: inquiry.email,
        mobileNo: inquiry.mobileNo,
        source: inquiry.source,
        isSynced: inquiry.isSynced,
      );
      newQuotationId = await QuotationRepo.insertQuotation(quotation);
    } catch (e) {
      AppUtils.showlog("error converting customer to quotation : $e");
    }
  }

  //convert inq product to quotation product
  Future<void> convertInquiryProductToQuotationProduct(
    List<InquiryProductModel> inquiryProduct,
  ) async {
    final int quotationId;
    if (newQuotationId != 0) {
      quotationId = newQuotationId;
    } else {
      quotationId = await QuotationRepo().getNextQuotationId() - 1;
    }
    try {
      for (var inquiryProduct in inquiryProduct) {
        final quotationProduct = QuotationProductModel(
          quotationId: quotationId,
          createdBy: inquiryProduct.createdBy,
          updatedBy: inquiryProduct.updatedBy,
          createdAt: inquiryProduct.createdAt,
          updatedAt: inquiryProduct.updatedAt,
          productId: inquiryProduct.productId,
          quantity: inquiryProduct.quantity,
          remark: inquiryProduct.remark,
        );
        await QuotationRepo.insertQuotationProduct(quotationProduct);
      }
    } catch (e) {
      AppUtils.showlog(
        "Error converting inquiry product to quotation product: $e",
      );
    }
  }

  Future<void> convertInquiryFollowupToQuotationFollowup(
    List<InquiryFollowupModel> inquiryFollowup,
  ) async {
    final int quotationId;
    if (newQuotationId != 0) {
      quotationId = newQuotationId;
    } else {
      quotationId = await QuotationRepo().getNextQuotationId() - 1;
    }
    try {
      for (var inquiryFollowup in inquiryFollowup) {
        final quotationFollowup = QuotationFollowupModel(
          quotationId: quotationId,
          createdBy: inquiryFollowup.createdBy,
          updatedBy: inquiryFollowup.updatedBy,
          createdAt: inquiryFollowup.createdAt,
          updatedAt: inquiryFollowup.updatedAt,
          followupDate: inquiryFollowup.followupDate,
          followupType: inquiryFollowup.followupType,
          followupStatus: inquiryFollowup.followupStatus,
          followupRemarks: inquiryFollowup.followupRemarks,
          followupAssignedTo: inquiryFollowup.followupAssignedTo,
          isSynced: inquiryFollowup.isSynced,
        );
        await QuotationRepo.insertQuotationFollowup(quotationFollowup);
      }
    } catch (e) {
      AppUtils.showlog(
        "Error converting inquiry followup to quotation followup: $e",
      );
    }
  }
}

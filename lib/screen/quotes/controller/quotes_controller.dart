import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/quotes/model/quote_invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:crm/screen/orders/models/order_followuo_model.dart';
import 'package:crm/screen/orders/models/order_model.dart';
import 'package:crm/screen/orders/models/order_product_model.dart';
import 'package:crm/screen/orders/models/order_terms_model.dart';
import 'package:crm/screen/orders/repo/order_repo.dart';
import 'package:crm/screen/quotes/model/quotation_followup_model.dart';
import 'package:crm/screen/quotes/model/quotation_model.dart';
import 'package:crm/screen/quotes/model/quotation_product_model.dart';
import 'package:crm/screen/quotes/model/quotation_terms_model.dart';
import 'package:crm/screen/quotes/repo/quotation_repo.dart';

class QuotesController extends GetxController {
  RxString? selectedProduct = "".obs;
  RxString? selectedUOM = "".obs;

  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};

  bool isEdit = false;
  String? no;

  @override
  void onInit() async {
    super.onInit();
    _initializeControllersAndFocusNodes();
    await getQuotationList();
    await getProductList();
    await getQuotationProductList();
    await getCustomersList();
    await getAllTerms();
    await getUomList();
    await getUid();

    // await getSelectedTerms();

    // Set initial quotation number based on the total number of quotations
    if (isEdit == true) {
      await setEditDetails();
    } else {
      // controllers['num']!.text = (quotationList.length + 1).toString();
      controllers['num']!.text = (await QuotationRepo().getNextQuotationId())
          .toString();
      controllers['date']!.text = dateFormat.format(DateTime.now());
    }
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
      "subject",
      "quantity",
      "rate",
      "amount",
      "discount",
      "remarks",
      "followupDate",
      "followupType",
      "followupStatus",
      "followupRemarks",
      "followupAssignedTo",
      "termsAndConditions",
    ];

    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
  }

  void updateQuotationTermsList() {
    if (selectedTerms.isEmpty) {
      quotationTermsList.clear();
      return;
    }

    // Efficiently find all selected terms without nested loops
    final selectedTermModels = allTerms
        .where((term) => selectedTerms.contains(term.id))
        .toList();

    quotationTermsList.value = selectedTermModels.map((term) {
      return QuotationTermsModel(
        quotationId: int.parse(controllers['num']!.text),
        termId: term.id,
      );
    }).toList();
  }

  final dateFormat = DateFormat("dd/MM/yyyy");

  // void updateProduct(String? value) {
  //   selectedProduct?.value = value ?? "";
  // }

  void updateUOM(String? value) {
    selectedUOM?.value = value ?? "";
  }

  // void _disposeControllersAndFocusNodes() {
  //   controllers.forEach((key, controller) => controller.dispose());
  //   focusNodes.forEach((key, focusNode) => focusNode.dispose());
  // }

  // @override
  // void onClose() {
  //   _disposeControllersAndFocusNodes();
  //   selectedTerms.clear();
  //   super.onClose();
  // }

  // @override
  // void dispose() {
  //   _disposeControllersAndFocusNodes();
  //   selectedCustomer.value = '';
  //   selectedProduct?.value = '';
  //   selectedUOM?.value = '';
  //   super.dispose();
  // }

  Future<void> setEditDetails() async {
    int intNo = int.parse(no ?? '');

    controllers['num']!.text = no!;
    controllers['date']!.text = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .date!;
    controllers['name1']!.text = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    selectedCustomer.value = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    controllers['email']!.text = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .email!;
    controllers['mobile']!.text = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .mobileNo!;
    controllers['social']!.text = quotationList
        .firstWhereOrNull((element) => element.id == intNo)!
        .source!;
    controllers['subject']!.text =
        quotationList
            .firstWhereOrNull((element) => element.id == intNo)!
            .subject ??
        '';
    await getQuotationProductList();
  }

  void calculateAmount() {
    final quantityText = controllers["quantity"]!.text;
    final rateText = controllers["rate"]!.text;
    final discountText = controllers["discount"]!.text;

    if (quantityText.isNotEmpty &&
        rateText.isNotEmpty &&
        discountText.isNotEmpty) {
      final quantity = double.tryParse(quantityText) ?? 0.0;
      final rate = double.tryParse(rateText) ?? 0.0;
      final discount = double.tryParse(discountText) ?? 0.0;
      final amount = quantity * rate * (1 - discount / 100);
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

  final RxList<QuotationModel> quotationList = <QuotationModel>[].obs;
  final RxList<QuotationModel> filterendList = <QuotationModel>[].obs;

  var customerList = <String, String>{}.obs;
  var selectedCustomer = "".obs;
  var productList = <ProductModel>[].obs;
  RxList<QuotationProductModel> quotationProductList =
      <QuotationProductModel>[].obs;
  var uomList = <UomModel>[].obs;

  /// Search for customer name or number
  void searchResult(String val) {
    AppUtils.showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = quotationList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = quotationList.where((item) {
      final custName = item.custName1?.toLowerCase();
      final uid = item.id
          .toString()
          .toLowerCase(); // Assuming uid is a string or can be converted to one

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid.contains(lowerCaseQuery));
    }).toList();
  }

  // -------- Lists for dropdown and selections -------

  ///get all product list
  Future<void> getProductList() async {
    try {
      final result = await ProductRepo.getAllProducts();
      productList.assignAll(result);
    } catch (e) {
      AppUtils.showlog("error on get product list : $e");
    }
  }

  Future<void> getUomList() async {
    try {
      final result = await UomRepo.getAllUom();
      uomList.assignAll(result);
      AppUtils.showlog("uom list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      AppUtils.showlog("Error getting UOM list : $e");
    }
  }

  /// get quotation product list
  Future<void> getQuotationProductList() async {
    try {
      final result = await QuotationRepo.getAllQuotationProducts();
      AppUtils.showlog(
        "getQuotationProductList result : ${result.map((e) => e.toJson()).toList()}",
      );
      quotationProductList.assignAll(
        result
            .where(
              (element) =>
                  element.quotationId == int.tryParse(controllers['num']!.text),
            )
            .toList(),
      );
      AppUtils.showlog(
        "quotation product list : ${result.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      AppUtils.showlog("error on get quotation product list : $e");
    }
  }

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

  /// get quotation list
  Future<void> getQuotationList() async {
    try {
      final result = await QuotationRepo.getAllQuotations();
      quotationList.assignAll(result);
      filterendList.value = quotationList;
      AppUtils.showlog(
        "quotation list : ${result.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      AppUtils.showlog("error on get quotation list : $e");
    }
  }

  // ----------------------------------------------------------------------------------------

  ///add Customer
  Future<void> addQuotationCustomer() async {
    try {
      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      AppUtils.showlog("custName : $custName");
      AppUtils.showlog("custId : $custId");

      final quotationCustomer = QuotationModel(
        createdBy: uid,
        updatedBy: uid,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        // custName2: controllers["name2"]!.text,
        date: controllers["date"]!.text,
        email: controllers["email"]!.text,
        mobileNo: controllers["mobile"]!.text,
        source: controllers["social"]!.text,
        subject: controllers["subject"]!.text,
      );

      AppUtils.showlog(
        "added quotation customer ----> ${quotationCustomer.toJson()}",
      );

      int result = await QuotationRepo.insertQuotation(quotationCustomer);
      // showSuccessSnackBar("Customer added successfully");
      AppUtils.showlog("insert quotation customer ----> $result");
      await getQuotationList();
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

  ///add quotation & product id to table so we have track of for a customer how many products quotation we have
  /*  Future<void> addQuotationProductID() async {
    try {
      final quoteId = int.parse(controllers['num']!.text);

      final quotProdId = QuotationProductModel(
        quotationId: quoteId,
        productId: getProductId(selectedProduct!.value),
        quantity: int.parse(controllers["quantity"]!.text),
        remark: controllers['remarks']!.text,
        discount: double.parse(controllers['discount']!.text),
      );

      AppUtils.showlog("quotation id : ${quotProdId.quotationId}");
      AppUtils.showlog("product id : ${quotProdId.productId}");

      int result = await QuotationRepo.insertQuotationProduct(quotProdId);
      AppUtils.showlog("insert quotation product ----> $result");
      showSuccessSnackBar("Product added successfully");
      await getQuotationProductList();
    } catch (e) {
      showErrorSnackBar("Error adding product");
      AppUtils.showlog("Error adding product & quotation ID : $e");
    }
  }
*/

  String? uid;
  Future<void> getUid() async {
    uid = await AppUtils.uid;
  }

  RxList<QuotationProductModel> tempProductList = <QuotationProductModel>[].obs;

  void addtempProductList() {
    try {
      final quoteId = int.parse(controllers['num']!.text);
      AppUtils.showlog("quotation id : $quoteId");
      tempProductList.add(
        QuotationProductModel(
          quotationId: quoteId,
          createdBy: uid,
          updatedBy: uid,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          productId: getProductId(selectedProduct!.value),
          quantity: int.parse(controllers["quantity"]!.text),
          remark: controllers['remarks']!.text,
          discount: double.parse(controllers['discount']!.text),
        ),
      );

      quotationProductList.assignAll(tempProductList);
      AppUtils.showlog(
        "temp product list : ${tempProductList.map((e) => e.toJson()).toList()}",
      );
      showSuccessSnackBar("Product added successfully");
    } catch (e) {
      showErrorSnackBar("Error adding product");
      AppUtils.showlog("Error adding temp product list : $e");
    }
  }

  Future<void> addQuotationProductID() async {
    try {
      for (var product in tempProductList) {
        int result = await QuotationRepo.insertQuotationProduct(product);
        AppUtils.showlog("insert quotation product -----> $result");
        await getQuotationProductList();
      }
    } catch (e) {
      showErrorSnackBar("Error adding product");
      AppUtils.showlog("Error adding product list : $e");
    }
  }

  ///save quotation
  Future<void> submitQuotation() async {
    try {
      await addQuotationCustomer(); // customer
      await addQuotationProductID();
      // await addProduct(); // product
      // await addQuotationProductID(); // both's id // already adding on ADD button
      showSuccessSnackBar("Quotation submitted successfully");
    } catch (e) {
      showErrorSnackBar("Error submitting quotation");
      AppUtils.showlog("Error submitting quotation : $e");
    }
  }

  Future<void> deleteQuotation({required int id}) async {
    try {
      await QuotationRepo.deleteQuotation(id);
      await getQuotationList();
      await QuotationRepo.deleteQuotationProduct(id);
      showSuccessSnackBar("Quotation deleted successfully");
      await getQuotationProductList();
    } catch (e) {
      showErrorSnackBar("Error deleting quotation");
      AppUtils.showlog("Error deleting quotation : $e");
    }
  }

  Future<int> updateQuotationProduct() async {
    try {
      if (tempProductList != quotationProductList) {
        for (var element in tempProductList) {
          int result = await QuotationRepo.insertQuotationProduct(element);
          AppUtils.showlog("updated quotation product ----> $result");
          await getQuotationProductList();
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

  Future<void> updateQuotation() async {
    try {
      int quotationId = int.parse(controllers['num']!.text);

      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      AppUtils.showlog("custName : $custName");
      AppUtils.showlog("custId : $custId");

      final quotation = QuotationModel(
        id: quotationId,
        createdBy: uid,
        updatedBy: uid,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        custId: int.parse(custId!),
        custName1: selectedCustomer.value,
        // custName2: "controllers['name2']!.text",
        date: controllers['date']!.text,
        email: controllers['email']!.text,
        mobileNo: controllers['mobile']!.text,
        source: controllers['social']!.text,
        subject: controllers['subject']!.text,
        isSynced: 0,
      );
      AppUtils.showlog("update quotation ----> ${quotation.toJson()}");
      int result = await QuotationRepo.updateQuotation(quotation);
      AppUtils.showlog("updated quotation ----> $result");

      int updateProduct = await updateQuotationProduct();
      AppUtils.showlog("updated product ----> $updateProduct");

      showSuccessSnackBar("Quotation Updated Successfully");
    } catch (e) {
      showErrorSnackBar("Error updating quotation");
      AppUtils.showlog("Error update quotation : $e");
    }
  }

  // -------------------------------------------------------------------------
  // MARK: Quotation Follow up

  final selectedFollowupDate = "".obs;
  final selectedFollowupType = "".obs;
  final selectedFollowupStatus = "".obs;
  final selectedFollowupRemarks = "".obs;
  final selectedFollowupAssignedTo = "".obs;

  RxList<QuotationFollowupModel> quotationFollowupList =
      <QuotationFollowupModel>[].obs;

  ///GET SELECTED Followup DETAIL's
  Future<void> setSelectedFollowupDetail(int selectedFolloupId) async {
    try {
      final result = await QuotationRepo.getQuotationFollowupById(
        selectedFolloupId,
      );
      AppUtils.showlog("selected followup detail : ${result.toJson()}");
      selectedFollowupAssignedTo.value = result.followupAssignedTo!;
      selectedFollowupDate.value = result.followupDate!;
      selectedFollowupRemarks.value = result.followupRemarks!;
      controllers['followupRemarks']!.text = result.followupRemarks!;
      controllers['followupDate']!.text = result.followupDate!;
      controllers['followupAssignedTo']!.text = result.followupAssignedTo!;
    } catch (e) {
      AppUtils.showlog("Error getting selected followup detail : $e");
    }
  }

  ///GET FOLLOWUP LIST
  ///
  ///return only selected quotation assigned followups
  Future<List<QuotationFollowupModel>> getQuotationFollowupList(
    int quotationId,
  ) async {
    try {
      final result = await QuotationRepo.getQuotationFollowupListByQuotationId(
        quotationId,
      );
      quotationFollowupList.assignAll(result);
      AppUtils.showlog(
        "quotation followup list : ${result.map((e) => e.toJson()).toList()}",
      );
      return result;
    } catch (e) {
      AppUtils.showlog("Error getting quotation followup list : $e");
      return [];
    }
  }

  ///ADD FOLLOWUP
  Future<void> addQuotationFollowup(String quotationId) async {
    try {
      int intId = int.parse(quotationId);

      final quotationFollowup = QuotationFollowupModel(
        quotationId: intId,
        followupDate: controllers['followupDate']!.text,
        followupStatus: selectedFollowupStatus.value,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: selectedFollowupAssignedTo.value,
      );
      AppUtils.showlog(
        "added quotation followup ----> ${quotationFollowup.toJson()}",
      );
      int result = await QuotationRepo.insertQuotationFollowup(
        quotationFollowup,
      );
      await getQuotationFollowupList(intId);
      showSuccessSnackBar("Quotation followup added successfully");
      AppUtils.showlog("insert quotation followup ----> $result");
    } catch (e) {
      showErrorSnackBar("Error adding quotation followup");
      AppUtils.showlog("Error adding quotation followup : $e");
    }
  }

  RxBool followupSelected = false.obs;

  Future<void> updateQuotationFollowup(String quotationId) async {
    try {
      int intId = int.parse(quotationId);
      final quotationFollowup = QuotationFollowupModel(
        id: intId,
        // createdBy: uid,
        updatedBy: uid,
        // createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        quotationId: intId,
        followupDate: controllers['followupDate']!.text,
        followupStatus: selectedFollowupStatus.value,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: selectedFollowupAssignedTo.value,
        isSynced: 0,
      );
      AppUtils.showlog(
        "update quotation followup ----> ${quotationFollowup.toJson()}",
      );
      int result = await QuotationRepo.insertQuotationFollowup(
        quotationFollowup,
      );
      showSuccessSnackBar("Quotation followup updated successfully");
      AppUtils.showlog("updated quotation followup ----> $result");
    } catch (e) {
      showErrorSnackBar("Error updating quotation followup");
      AppUtils.showlog("Error update quotation followup : $e");
    }
  }

  // --------------------------------------------------------------------------

  // MARK: Quotes Terms

  RxList<TermsModel> allTerms = <TermsModel>[].obs;
  RxList<QuotationTermsModel> quotationTermsList = <QuotationTermsModel>[].obs;
  RxList<int> selectedTerms = <int>[].obs;

  //Get all terms
  Future<void> getAllTerms() async {
    try {
      final result = await TermsRepo.getAllTerms();
      AppUtils.showlog("all terms : ${result.map((e) => e.toJson()).toList()}");
      allTerms.assignAll(result);
    } catch (e) {
      AppUtils.showlog("Error getting all terms : $e");
    }
  }

  //Get all selected terms && set selected
  Future<void> getSelectedTerms(int? quotationId) async {
    try {
      AppUtils.showlog("Quotation ID: $quotationId");
      final result = await QuotationRepo.getSelectedTerms(quotationId!);
      AppUtils.showlog(
        "selected terms : ${result.map((e) => e.toJson()).toList()}",
      );
      quotationTermsList.assignAll(result);

      if (result.isNotEmpty) {
        // for (var term in result) {
        //   selectedTerms.add(int.parse(term.termId ?? ''));
        // }
        selectedTerms.assignAll(
          result.map((term) => term.termId ?? 0).toSet().toList(),
        );
      } else {
        AppUtils.showlog("No selected terms found");
      }

      if (selectedTerms.isNotEmpty) {
        AppUtils.showlog("Selected terms : ${selectedTerms.toList()}");
      }
    } catch (e) {
      AppUtils.showlog("Error getting selected terms : $e");
    }
  }

  /// Handles all logic for selecting/deselecting a term
  void toggleTermSelection(int termId) {
    // 1. Update the selection set
    if (selectedTerms.contains(termId)) {
      selectedTerms.remove(termId);
    } else {
      selectedTerms.add(termId);
    }

    // 2. Efficiently update the quotation list
    updateQuotationTerms();
  }

  /// Helper method to rebuild the quotation list
  void updateQuotationTerms() {
    // Find all the full TermModels that are currently selected
    final selectedTermModels = allTerms.where((term) {
      return selectedTerms.contains(term.id);
    });

    // Map these models to the QuotationTermsModel
    quotationTermsList.value = selectedTermModels.map((term) {
      return QuotationTermsModel(
        updatedAt: DateTime.now().toString(),
        updatedBy: uid,
        quotationId: int.parse(controllers['num']!.text),
        termId: term.id,
        isSynced: 0,
      );
    }).toList();

    AppUtils.showlog("Selected Terms: ${selectedTerms.toList()}");
  }

  // add new selected term
  Future<void> addQuotationTerms(int quotationId) async {
    try {
      AppUtils.showlog("add quote term : Quatation ID --> $quotationId");
      AppUtils.showlog(
        "Quotation Term List : ${quotationTermsList.map((e) => e.toJson()).toList()}",
      );
      for (var term in quotationTermsList) {
        final quotationTerms = QuotationTermsModel(
          updatedAt: DateTime.now().toString(),
          updatedBy: uid,
          createdAt: DateTime.now().toString(),
          createdBy: uid,
          quotationId: quotationId,
          termId: term.termId,
        );
        AppUtils.showlog(
          "added quotation terms ----> ${quotationTerms.toJson()}",
        );
        int result = await QuotationRepo.insertQuotationTerms(quotationTerms);
        AppUtils.showlog("insert quotation terms ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error adding quotation terms : $e");
    }
  }

  // -----------------------------------------------------------------------

  // MARK: Quotes to order

  ///steps
  ///1. get quotation customer from [Quotation table] and add it to order table
  ///2. on completion of step 1. add quotation products to order products
  ///3. on completion of step 2. add quotation terms to order terms
  ///4. on completion of step 3. add quotation followups to order followup
  ///

  // convert quotation to order
  Future<void> convertQuotationToOrder({required String quotationId}) async {
    try {
      //quotation to order customer
      final currentQuotation = await QuotationRepo.getQuotationById(
        quotationId,
      );
      AppUtils.showlog("current quotation : ${currentQuotation.toJson()}");
      await convertQuotationToOrderCustomer(currentQuotation);

      //quotation to order product
      final quotationProductList =
          await QuotationRepo.getAllQuotationProducts();

      final selectedQuotationProductList = quotationProductList
          .where((element) => element.quotationId == int.parse(quotationId))
          .toList();

      AppUtils.showlog(
        "selected quotation product list : ${selectedQuotationProductList.map((e) => e.toJson()).toList()}",
      );
      await convertQuotationToOrderProduct(selectedQuotationProductList);

      //quotation to order terms
      final quotationTermsList = await QuotationRepo.getSelectedTerms(
        int.parse(quotationId),
      );
      AppUtils.showlog(
        "quotation terms list : ${quotationTermsList.map((e) => e.toJson()).toList()}",
      );
      await convertQuotationToOrderTerms(quotationTermsList);

      //quotation to order followup
      // final quotationFollowupList =
      //     await QuotationRepo.getQuotationFollowupListByQuotationId(
      //       int.parse(quotationId),
      //     );
      // AppUtils.showlog(
      //   "quotation followup list : ${quotationFollowupList.map((e) => e.toJson()).toList()}",
      // );
      // await convertQuotationToOrderFollowup(quotationFollowupList);
      showSuccessSnackBar("Quotation converted to order successfully");
    } catch (e) {
      showErrorSnackBar("Error converting quotation to order");
      AppUtils.showlog("Error converting quotation to order : $e");
    }
  }

  int newOrderId = 0;

  //convert quote to order customer
  Future<void> convertQuotationToOrderCustomer(QuotationModel quotation) async {
    try {
      final orderCustomer = OrderModel(
        createdBy: quotation.createdBy,
        updatedBy: quotation.updatedBy,
        createdAt: quotation.createdAt,
        updatedAt: quotation.updatedAt,
        custId: quotation.custId,
        custName1: quotation.custName1,
        // custName2: quotation.custName2,
        date: quotation.date,
        email: quotation.email,
        mobileNo: quotation.mobileNo,
        source: quotation.source,
      );
      AppUtils.showlog("added order customer ----> ${orderCustomer.toJson()}");
      newOrderId = await OrderRepo.insertOrder(orderCustomer);
      AppUtils.showlog("insert order customer ----> $newOrderId");
    } catch (e) {
      AppUtils.showlog("Error converting quotation to order customer : $e");
    }
  }

  // convert quotation to order product
  Future<void> convertQuotationToOrderProduct(
    List<QuotationProductModel> quotationProductList,
  ) async {
    try {
      for (var product in quotationProductList) {
        final orderProduct = OrderProductModel(
          orderId: newOrderId,
          productId: product.productId,
          quantity: product.quantity ?? 0,
          discount: product.discount,
          remark: product.remark,
        );
        AppUtils.showlog("added order product ----> ${orderProduct.toJson()}");
        int result = await OrderRepo.insertOrderProduct(orderProduct);
        AppUtils.showlog("insert order product ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error converting quotation to order product : $e");
    }
  }

  //convert quotation terms to order terms
  Future<void> convertQuotationToOrderTerms(
    List<QuotationTermsModel> termsList,
  ) async {
    try {
      for (var term in termsList) {
        final orderTerms = OrderTermsModel(
          orderId: newOrderId,
          termId: term.termId,
        );
        AppUtils.showlog("added order terms ----> ${orderTerms.toJson()}");
        int result = await OrderRepo.insertOrderTerms(orderTerms);
        AppUtils.showlog("insert order terms ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error converting quotation to order terms : $e");
    }
  }

  //convert quotation followup to order followup
  Future<void> convertQuotationToOrderFollowup(
    List<QuotationFollowupModel> followupList,
  ) async {
    try {
      for (var followup in followupList) {
        final orderFollowup = OrderFollowupModel(
          orderId: newOrderId,
          followupDate: followup.followupDate,
          followupStatus: followup.followupStatus,
          followupType: followup.followupType,
          followupRemarks: followup.followupRemarks,
          followupAssignedTo: followup.followupAssignedTo,
        );
        AppUtils.showlog(
          "added order followup ----> ${orderFollowup.toJson()}",
        );
        int result = await OrderRepo.insertOrderFollowup(orderFollowup);
        AppUtils.showlog("insert order followup ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error converting quotation to order followup : $e");
    }
  }

  // ----------------------------------------------------------------------------

  //MARK: Copy Quote

  ///Steps
  ///1. get customer details
  ///2. get product details
  ///3. get terms details
  ///4. get followup details
  ///

  Future<void> copyQuotation({required String quotationId}) async {
    try {
      //1. get customer details
      final selectedQuote = await QuotationRepo.getQuotationById(quotationId);
      AppUtils.showlog("Selected quote : ${selectedQuote.toJson()}");
      await copyCustomer(selectedQuote);

      //2. get product details
      final quotationProductList =
          await QuotationRepo.getAllQuotationProducts();

      final selectedQuotationProductList = quotationProductList
          .where((element) => element.quotationId == int.parse(quotationId))
          .toList();

      AppUtils.showlog(
        "selected quotation product list : ${selectedQuotationProductList.map((e) => e.toJson()).toList()}",
      );
      await copyProductList(selectedQuotationProductList);

      //3. get terms details
      final quotationTermsList = await QuotationRepo.getSelectedTerms(
        int.parse(quotationId),
      );
      AppUtils.showlog(
        "quotation terms list : ${quotationTermsList.map((e) => e.toJson()).toList()}",
      );
      await copyTerms(quotationTermsList);

      //4. get followup details
      final quotationFollowupList =
          await QuotationRepo.getQuotationFollowupListByQuotationId(
            int.parse(quotationId),
          );
      AppUtils.showlog(
        "quotation followup list : ${quotationFollowupList.map((e) => e.toJson()).toList()}",
      );
      await copyFollowup(quotationFollowupList);
    } catch (e) {
      AppUtils.showlog("Error copying quotation : $e");
    }
  }

  //create new customer
  static Future<void> copyCustomer(QuotationModel quotation) async {
    try {
      final newCustomer = QuotationModel(
        createdBy: quotation.createdBy,
        updatedBy: quotation.updatedBy,
        createdAt: quotation.createdAt,
        updatedAt: quotation.updatedAt,
        custId: quotation.custId,
        custName1: quotation.custName1,
        // custName2: quotation.custName2,
        date: quotation.date,
        email: quotation.email,
        mobileNo: quotation.mobileNo,
        source: quotation.source,
      );
      AppUtils.showlog("added new customer ----> ${newCustomer.toJson()}");
      int result = await QuotationRepo.insertQuotation(newCustomer);
      AppUtils.showlog("insert new customer ----> $result");
    } catch (e) {
      AppUtils.showlog("Error copying customer : $e");
    }
  }

  //create productList
  static Future<void> copyProductList(
    List<QuotationProductModel> productList,
  ) async {
    try {
      for (var product in productList) {
        final newProduct = QuotationProductModel(
          quotationId: product.quotationId,
          createdBy: product.createdBy,
          updatedBy: product.updatedBy,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
          productId: product.productId,
          quantity: product.quantity,
          discount: product.discount,
          remark: product.remark,
        );
        AppUtils.showlog("added new product ----> ${newProduct.toJson()}");
        int result = await QuotationRepo.insertQuotationProduct(newProduct);
        AppUtils.showlog("insert new product ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error copying product list : $e");
    }
  }

  //copy terms
  static Future<void> copyTerms(List<QuotationTermsModel> termsList) async {
    try {
      for (var term in termsList) {
        final newTerm = QuotationTermsModel(
          quotationId: term.quotationId,
          createdBy: term.createdBy,
          updatedBy: term.updatedBy,
          createdAt: term.createdAt,
          updatedAt: term.updatedAt,
          termId: term.termId,
        );
        AppUtils.showlog("added new term ----> ${newTerm.toJson()}");
        int result = await QuotationRepo.insertQuotationTerms(newTerm);
        AppUtils.showlog("insert new term ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error copying terms : $e");
    }
  }

  //copy followup
  static Future<void> copyFollowup(
    List<QuotationFollowupModel> followupList,
  ) async {
    try {
      for (var followup in followupList) {
        final newFollowup = QuotationFollowupModel(
          quotationId: followup.quotationId,
          createdBy: followup.createdBy,
          updatedBy: followup.updatedBy,
          createdAt: followup.createdAt,
          updatedAt: followup.updatedAt,
          followupDate: followup.followupDate,
          followupStatus: followup.followupStatus,
          followupType: followup.followupType,
          followupRemarks: followup.followupRemarks,
          followupAssignedTo: followup.followupAssignedTo,
        );
        AppUtils.showlog("added new followup ----> ${newFollowup.toJson()}");
        int result = await QuotationRepo.insertQuotationFollowup(newFollowup);
        AppUtils.showlog("insert new followup ----> $result");
      }
    } catch (e) {
      AppUtils.showlog("Error copying followup : $e");
    }
  }

  // ------------------------------------------------------------------------------------------
  //-------------------- MARK: Invoice
  // ------------------------------------------------------------------------------------------

  final invoiceCustName = "".obs;
  final invoiceCustAddress = "".obs;
  final invoiceSubject = "".obs;
  final invoiceProductList = <ProductItem>[].obs;
  final invoiceTermsList = <QuotationTermsModel>[].obs;

  Future<QuotationInvoiceModel> setQuoteInvoiceData(String quotationId) async {
    try {
      AppUtils.showlog("quotation id : $quotationId");

      final currentQuotation = await QuotationRepo.getQuotationById(
        quotationId,
      );

      AppUtils.showlog("current quotation : ${currentQuotation.toJson()}");

      final customerDetails = await ContactsRepo.getContactById(
        currentQuotation.custId.toString(),
      );

      //get customer name & address
      invoiceCustName.value = currentQuotation.custName1 ?? '';
      invoiceCustAddress.value =
          "${customerDetails.address}, ${customerDetails.city}, ${customerDetails.state}, ${customerDetails.country}";
      invoiceSubject.value = currentQuotation.subject ?? '';

      //get products
      final productList = await QuotationRepo.getAllQuotationProducts();
      final selectedProductList = productList.where((element) {
        return element.quotationId == int.parse(quotationId);
      }).toList();

      AppUtils.showlog(
        "Invoice product list : ${invoiceProductList.map((e) => e.toJson()).toList()}",
      );
      List<ProductItem> productItems = [];

      //get selected product details from product repo
      final allProducts = await ProductRepo.getAllProducts();

      for (var product in selectedProductList) {
        productItems.add(
          ProductItem(
            itemQty: product.quantity,
            itemAmount: double.parse(
              allProducts
                      .where((e) => e.productId == product.productId)
                      .first
                      .productRate ??
                  '0',
            ),
            itemRate: double.parse(
              allProducts
                      .where((e) => e.productId == product.productId)
                      .first
                      .productRate ??
                  '0',
            ),
            itemName:
                allProducts
                    .where((e) => e.productId == product.productId)
                    .first
                    .productName ??
                '',
            itemHsn: "What is HSN ?",
          ),
        );
      }

      invoiceProductList.value = productItems;
      //get terms
      final selectedTerms = await QuotationRepo.getSelectedTerms(
        int.parse(quotationId),
      );

      invoiceTermsList.value = selectedTerms;

      final QuotationInvoiceModel invoiceData = QuotationInvoiceModel(
        custName: invoiceCustName.value,
        custAddress: invoiceCustAddress.value,
        subject: invoiceSubject.value,
        // productList: invoiceProductList.mapMany()
        // termsList: invoiceTermsList.map((e) => allTerms.firstWhere((term) => term.id == e.termId).title!).toList(),
      );
      return invoiceData;
    } catch (e) {
      AppUtils.showlog("Error setting quote invoice data : $e");
      rethrow;
    }
  }
}

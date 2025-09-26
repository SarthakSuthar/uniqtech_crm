import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/quotes/model/quotation_followup_model.dart';
import 'package:crm/screen/quotes/model/quotation_model.dart';
import 'package:crm/screen/quotes/model/quotation_product_model.dart';
import 'package:crm/screen/quotes/model/quotation_terms_model.dart';
import 'package:crm/screen/quotes/repo/quotation_repo.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    // await getSelectedTerms();

    // Set initial quotation number based on the total number of quotations
    if (isEdit == true) {
      await setEditDetails();
    } else {
      controllers['num']!.text = (quotationList.length + 1).toString();
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
      "quntity",
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

  final dateFormat = DateFormat("d/M/yyyy");

  // void updateProduct(String? value) {
  //   selectedProduct?.value = value ?? "";
  // }

  void updateUOM(String? value) {
    selectedUOM?.value = value ?? "";
  }

  void _disposeControllersAndFocusNodes() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
  }

  @override
  void onClose() {
    _disposeControllersAndFocusNodes();
    selectedTerms.clear();
    super.onClose();
  }

  @override
  void dispose() {
    _disposeControllersAndFocusNodes();
    selectedCustomer.value = '';
    selectedProduct?.value = '';
    selectedUOM?.value = '';
    super.dispose();
  }

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
    await getQuotationProductList();
  }

  void calculateAmount() {
    final quntityText = controllers["quntity"]!.text;
    final rateText = controllers["rate"]!.text;
    final discountText = controllers["discount"]!.text;

    if (quntityText.isNotEmpty &&
        rateText.isNotEmpty &&
        discountText.isNotEmpty) {
      final quntity = double.tryParse(quntityText) ?? 0.0;
      final rate = double.tryParse(rateText) ?? 0.0;
      final discount = double.tryParse(discountText) ?? 0.0;
      final amount = quntity * rate * (1 - discount / 100);
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
  var quotationProductList = <QuotationProductModel>[].obs;

  /// Search for customer name or number
  void searchResult(String val) {
    showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = quotationList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = quotationList.where((item) {
      final custName = item.custName1?.toLowerCase();
      final uid = item.uid
          ?.toLowerCase(); // Assuming uid is a string or can be converted to one

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid?.contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  // -------- Lists for dropdown and selections -------

  ///get all product list
  Future<void> getProductList() async {
    try {
      final result = await ProductRepo.getAllProducts();
      productList.assignAll(result);
    } catch (e) {
      showlog("error on get product list : $e");
    }
  }

  /// get quotation product list
  Future<void> getQuotationProductList() async {
    try {
      final result = await QuotationRepo.getAllQuotationProducts();
      showlog(
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
      showlog(
        "quotation product list : ${result.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      showlog("error on get quotation product list : $e");
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
        (key, value) => showlog("Customer list $key : $value"),
      );
    } catch (e) {
      showlog("error on get customers list : $e");
    }
  }

  /// get user details by id
  Future<void> getSelectedContactDetails(String name) async {
    try {
      showlog("name --> $name");
      final id = customerList[name] ?? '';
      showlog("get user details by id --> $id");

      final result = await ContactsRepo.getContactById(id);
      controllers["email"]?.text = result.email!;
      controllers["mobile"]?.text = result.mobileNo!;
      showlog("selected contact details : ${result.toJson()}");
    } catch (e) {
      showlog("error on get user details : $e");
    }
  }

  /// get quotation list
  Future<void> getQuotationList() async {
    try {
      final result = await QuotationRepo.getAllQuotations();
      quotationList.assignAll(result);
      filterendList.value = quotationList;
      showlog("quotation list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("error on get quotation list : $e");
    }
  }

  // ------------------------

  ///add Customer
  Future<void> addQuotationCustomer() async {
    try {
      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      showlog("custName : $custName");
      showlog("custId : $custId");

      final quotationCustomer = QuotationModel(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        custName2: controllers["name2"]!.text,
        date: controllers["date"]!.text,
        email: controllers["email"]!.text,
        mobileNo: controllers["mobile"]!.text,
        source: controllers["social"]!.text,
      );

      showlog("added quotation customer ----> ${quotationCustomer.toJson()}");

      int result = await QuotationRepo.insertQuotation(quotationCustomer);
      showlog("insert quotation customer ----> $result");
      await getQuotationList();
    } catch (e) {
      showlog("error on add customer : $e");
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
      showlog("Error getting product id : $e");
      rethrow;
    }
  }

  ///add quotation & product id to table so we have track of for a customer how many products quotation we have
  Future<void> addQuotationProductID() async {
    try {
      final quotProdId = QuotationProductModel(
        quotationId: quotationList.length + 1,
        productId: getProductId(selectedProduct!.value),
        quentity: int.parse(controllers["quntity"]!.text),
      );

      showlog("quotation id : ${quotProdId.quotationId}");
      showlog("product id : ${quotProdId.productId}");

      int result = await QuotationRepo.insertQuotationProduct(quotProdId);
      showlog("insert quotation product ----> $result");
      await getQuotationProductList();
    } catch (e) {
      showlog("Error adding product & quotation ID : $e");
    }
  }

  ///save quotation
  Future<void> submitQuotation() async {
    try {
      await addQuotationCustomer(); // customer
      // await addProduct(); // product
      // await addQuotationProductID(); // both's id // already adding on ADD button
    } catch (e) {
      showlog("Error submitting quotation : $e");
    }
  }

  Future<void> deleteQuotation({required int id}) async {
    try {
      await QuotationRepo.deleteQuotation(id);
      await getQuotationList();
      await QuotationRepo.deleteQuotationProduct(id);
      await getQuotationProductList();
    } catch (e) {
      showlog("Error deleting quotation : $e");
    }
  }

  Future<void> updateQuotation() async {
    try {
      //TODO: implement update logic
      /* 
      If we re getting contact details & product details from their different masters
      What we need to update ????
      */
      final quotation = QuotationModel(
        id: int.parse(controllers['num']!.text),
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        custId: int.parse(controllers['custId']!.text),
        custName1: selectedCustomer.value,
        custName2: controllers['name2']!.text,
        date: controllers['date']!.text,
        email: controllers['email']!.text,
        mobileNo: controllers['mobile']!.text,
        source: controllers['social']!.text,
      );
      showlog("update quotation ----> ${quotation.toJson()}");
      // int result = await QuotationRepo.updateQuotation(quotation);
      // showlog("updated quotation ----> $result");
    } catch (e) {
      showlog("Error update quotation : $e");
    }
  }

  // MARK: Quotation Follow up ---------------- TODO: Hvae to impl

  final selectedFollowupDate = "".obs;
  final selectedFollowupType = "".obs;
  final selectedFollowupStatus = "".obs;
  final selectedFollowupRemarks = "".obs;
  final selectedFollowupAssignedTo = "".obs;

  final RxList<QuotationFollowupModel> quotationFollowupList =
      <QuotationFollowupModel>[].obs;

  ///GET SELECTED Followup DETAIL's
  Future<void> setSelectedFollowupDetail(int selectedFolloupId) async {
    try {
      final result = await QuotationRepo.getQuotationFollowupById(
        selectedFolloupId,
      );
      showlog("selected followup detail : ${result.toJson()}");
      selectedFollowupAssignedTo.value = result.followupAssignedTo!;
      selectedFollowupDate.value = result.followupDate!;
      selectedFollowupRemarks.value = result.followupRemarks!;
      selectedFollowupStatus.value = result.followupStatus!;
      selectedFollowupType.value = result.followupStatus!;
    } catch (e) {
      showlog("Error getting selected followup detail : $e");
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
      showlog(
        "quotation followup list : ${result.map((e) => e.toJson()).toList()}",
      );
      return result;
    } catch (e) {
      showlog("Error getting quotation followup list : $e");
      return [];
    }
  }

  ///ADD FOLLOWUP
  Future<void> addQuotationFollowup(int quotationId) async {
    try {
      final quotationFollowup = QuotationFollowupModel(
        quotationId: quotationId,
        followupDate: controllers['followupDate']!.text,
        followupStatus: controllers['followupStatus']!.text,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: controllers['followupAssignedTo']!.text,
      );
      showlog("added quotation followup ----> ${quotationFollowup.toJson()}");
      int result = await QuotationRepo.insertQuotationFollowup(
        quotationFollowup,
      );
      showlog("insert quotation followup ----> $result");
    } catch (e) {
      showlog("Error adding quotation followup : $e");
    }
  }

  // -------------- Quotes Terms ------------

  RxList<TermsModel> allTerms = <TermsModel>[].obs;
  RxList<QuotationTermsModel> quotationTermsList = <QuotationTermsModel>[].obs;
  RxList<int> selectedTerms = <int>[].obs;

  //Get all terms
  Future<void> getAllTerms() async {
    try {
      final result = await TermsRepo.getAllTerms();
      showlog("all terms : ${result.map((e) => e.toJson()).toList()}");
      allTerms.assignAll(result);
    } catch (e) {
      showlog("Error getting all terms : $e");
    }
  }

  //Get all selected terms && set selected
  Future<void> getSelectedTerms(int? quotationId) async {
    try {
      showlog("Quotation ID: $quotationId");
      final result = await QuotationRepo.getSelectedTerms(quotationId!);
      showlog("selected terms : ${result.map((e) => e.toJson()).toList()}");
      quotationTermsList.assignAll(result);

      if (result.isNotEmpty) {
        // for (var term in result) {
        //   selectedTerms.add(int.parse(term.termId ?? ''));
        // }
        selectedTerms.assignAll(
          result.map((term) => term.termId ?? 0).toSet().toList(),
        );
      } else {
        showlog("No selected terms found");
      }

      if (selectedTerms.isNotEmpty) {
        showlog("Selected terms : ${selectedTerms.toList()}");
      }
    } catch (e) {
      showlog("Error getting selected terms : $e");
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
        quotationId: int.parse(controllers['num']!.text),
        termId: term.id,
      );
    }).toList();

    showlog("Selected Terms: ${selectedTerms.toList()}");
  }

  // add new selected term
  Future<void> addQuotationTerms(int quotationId) async {
    try {
      showlog("add quote term : Quatation ID --> $quotationId");
      showlog(
        "Quotation Term List : ${quotationTermsList.map((e) => e.toJson()).toList()}",
      );
      for (var term in quotationTermsList) {
        final quotationTerms = QuotationTermsModel(
          quotationId: quotationId,
          termId: term.termId,
        );
        showlog("added quotation terms ----> ${quotationTerms.toJson()}");
        int result = await QuotationRepo.insertQuotationTerms(quotationTerms);
        showlog("insert quotation terms ----> $result");
      }
    } catch (e) {
      showlog("Error adding quotation terms : $e");
    }
  }
}

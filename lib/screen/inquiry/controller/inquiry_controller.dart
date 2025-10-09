import 'package:crm/app_const/utils/app_utils.dart';
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

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    super.onClose();
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    selectedCustomer.value = '';
    selectedProduct?.value = '';
    selectedUOM?.value = '';
    super.dispose();
  }

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
      showlog("uom list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("Error getting UOM list : $e");
    }
  }

  final RxList<InquiryModel> inquiryList = <InquiryModel>[].obs;
  final RxList<InquiryModel> filterendList = <InquiryModel>[].obs;

  /// Search for customer name or number
  void searchResult(String val) {
    showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = inquiryList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = inquiryList.where((item) {
      final custName = item.custName1?.toLowerCase();
      final uid = item.uid
          ?.toLowerCase(); // Assuming uid is a string or can be converted to one

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
      showlog("inquiry list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("error on get inquiry list : $e");
    }
  }

  var productList = <ProductModel>[].obs;

  ///get all product list
  Future<void> getProductList() async {
    try {
      final result = await ProductRepo.getAllProducts();
      productList.assignAll(result);
    } catch (e) {
      showlog("error on get product list : $e");
    }
  }

  var inquiryProductList = <InquiryProductModel>[].obs;

  /// get inquiry product list
  Future<void> getinquiryProductList() async {
    try {
      final result = await InquiryRepo.getAllInquiryProducts();
      showlog(
        "getinquiryProductList result : ${result.map((e) => e.toJson()).toList()}",
      );

      final numText = controllers['num']?.text ?? "";
      showlog("controllers['num']?.text --> $numText");
      final inquiryId = int.tryParse(numText);

      if (inquiryId == null) {
        showlog("Invalid inquiryId: $numText");
        inquiryProductList.clear();
        return;
      } else {
        showlog("inquiryId : $inquiryId");
      }

      inquiryProductList.assignAll(
        result.where((element) => element.inquiryId == inquiryId).toList(),
      );
      showlog(
        "inquiry product list : ${inquiryProductList.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      showlog("error on get inquiry product list : $e");
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

  // ------------------------

  ///add Customer
  Future<void> addInquiryCustomer() async {
    try {
      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      showlog("custName : $custName");
      showlog("custId : $custId");

      final inquiryCustomer = InquiryModel(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        custName2: controllers["name2"]!.text,
        date: controllers["date"]!.text,
        email: controllers["email"]!.text,
        mobileNo: controllers["mobile"]!.text,
        source: controllers["social"]!.text,
      );

      showlog("added inquiry customer ----> ${inquiryCustomer.toJson()}");

      int result = await InquiryRepo.insertInquiry(inquiryCustomer);
      showlog("insert inquiry customer ----> $result");
      await getInquiryList();
    } catch (e) {
      showlog("error on add customer : $e");
    }
  }

  /*
  do not need this as we not need to add new product 
  but we need to map product id with customer id in InquiryProductModel table
   */
  //add Product
  // Future<void> addProduct() async {
  //   try {

  //     showlog("added product ----> ${product.toJson()}");

  //     // int result = await ProductRepo.insertProduct(product);
  //   } catch (e) {
  //     showlog("Error adding product : $e");
  //   }
  // }

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

  ///add inquiry & product id to table so we have track of for a customer how many products inquiry we have
  Future<void> addInquiryProductID() async {
    try {
      final inquiryId = int.parse(controllers['num']!.text);

      showlog("Inquiry Id in addInquiryProductID : $inquiryId");

      final inqProdId = InquiryProductModel(
        inquiryId: inquiryId,
        productId: getProductId(selectedProduct!.value),
        quantity: int.parse(controllers["quantity"]!.text),
        remark: controllers["remarks"]!.text,
      );

      showlog("inquiry id : ${inqProdId.inquiryId}");
      showlog("product id : ${inqProdId.productId}");

      int result = await InquiryRepo.insertInquiryProduct(inqProdId);
      showlog("insert inquiry product ----> $result");
      await getinquiryProductList();
    } catch (e) {
      showlog("Error adding product & inquiry ID : $e");
    }
  }

  ///save inquiry
  Future<void> submitInquiry() async {
    try {
      await addInquiryCustomer(); // customer
      await getInquiryList();
    } catch (e) {
      showlog("Error submitting inquiry : $e");
    }
  }

  Future<void> deleteInquiry({required int id}) async {
    try {
      await InquiryRepo.deleteInquiry(id);
      await getInquiryList();
      await InquiryRepo.deleteInquiryProduct(id);
      await getinquiryProductList();
    } catch (e) {
      showlog("Error deleting inquiry : $e");
    }
  }

  Future<void> updateInquiry() async {
    try {
      //TODO: implement update logic
      /* 
      If we re getting contact details & product details from their different masters
      What we need to update ????
      */
      final inquiry = InquiryModel(
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
      showlog("updated inquiry ----> ${inquiry.toJson()}");
      // int result = await InquiryRepo.updateInquiry(inquiry);
      // showlog("update inquiry ----> $result");
    } catch (e) {
      showlog("Error update inquiry : $e");
    }
  }

  // MARK: Inquiry Follow up ----------------

  final selectedFollowupDate = "".obs;
  final selectedFollowupType = "".obs;
  final selectedFollowupStatus = "".obs;
  final selectedFollowupRemarks = "".obs;
  final selectedFollowupAssignedTo = "".obs;

  final RxList<InquiryFollowupModel> inquiryFollowupList =
      <InquiryFollowupModel>[].obs;

  ///GET SELECTED Followup DETAIL's
  Future<void> setSelectedFollowupDetail(int selectedFolloupId) async {
    try {
      final result = await InquiryRepo.getInquiryFollowupById(
        selectedFolloupId,
      );
      showlog("selected followup detail : ${result.toJson()}");
      selectedFollowupAssignedTo.value = result.followupAssignedTo!;
      selectedFollowupDate.value = result.followupDate;
      selectedFollowupRemarks.value = result.followupRemarks!;
      selectedFollowupStatus.value = result.followupStatus!;
      selectedFollowupType.value = result.followupStatus!;
    } catch (e) {
      showlog("Error getting selected followup detail : $e");
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
      showlog(
        "inquiry followup list : ${result.map((e) => e.toJson()).toList()}",
      );
      return result;
    } catch (e) {
      showlog("Error getting inquiry followup list : $e");
      return [];
    }
  }

  ///ADD FOLLOWUP
  Future<void> addInquiryFollowup(String inquiryId) async {
    try {
      int intId = int.parse(inquiryId);

      final inquiryFollowup = InquiryFollowupModel(
        inquiryId: intId,
        followupDate: controllers['followupDate']!.text,
        followupStatus: selectedFollowupStatus.value,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: selectedFollowupAssignedTo.value,
      );
      showlog("added inquiry followup ----> ${inquiryFollowup.toJson()}");
      int result = await InquiryRepo.insertInquiryFollowup(inquiryFollowup);
      showlog("insert inquiry followup ----> $result");
    } catch (e) {
      showlog("Error adding inquiry followup : $e");
    }
  }

  Future<void> updateInquiryFollowup(String inquiryId) async {
    try {
      int intId = int.parse(inquiryId);
      final inquiryFollowup = InquiryFollowupModel(
        inquiryId: intId,
        followupDate: controllers['followupDate']!.text,
        followupStatus: controllers['followupStatus']!.text,
        followupType: selectedFollowupType.value,
        followupRemarks: controllers['followupRemarks']!.text,
        followupAssignedTo: controllers['followupAssignedTo']!.text,
      );

      showlog("updated inquiry followup ----> ${inquiryFollowup.toJson()}");
      int result = await InquiryRepo.updateInquiryFollowup(inquiryFollowup);
      showlog("update inquiry followup ----> $result");
    } catch (e) {
      showlog("Error update inquiry followup : $e");
    }
  }

  // --------------------------------------------------------------------
  //MARK: Convert to Quotation

  ///Steps
  /// 1. get inquiry customer from [table] and add it to quotation table
  /// 2. on complethin of step 1 -> add data from product table into quotation product table
  /// 3. on completion of step 2 -> take data from inquiry followup table and add it to quotation followup table
  ///

  Future<void> convertInquiryToQuotation({required String inquiryId}) async {
    try {
      // get inquiry data and build Model objects

      // pars them into method calls below

      //get inquiry by id
      //create model
      //call convertInquiryCustomerToQuotationCustomer

      ////convertInquiryCustomerToQuotationCustomer
      final customerInquiry = await InquiryRepo.getInquiryById(inquiryId);
      showlog("customerInquiry : ${customerInquiry.toJson()}");
      await convertInquiryCustomerToQuotationCustomer(customerInquiry);

      //get product list for selected inquiry
      //parse list into convertInquiryProductToQuotationProduct

      final inquiryProductList = await InquiryRepo.getAllInquiryProducts();

      final selectedInquiryProductList = inquiryProductList
          .where((element) => element.inquiryId == int.parse(inquiryId))
          .toList();
      showlog(
        "inquiryProductList : ${selectedInquiryProductList.map((e) => e.toJson()).toList()}",
      );
      await convertInquiryProductToQuotationProduct(inquiryProductList);

      //get followup list for selected inquiry

      final inquiryFollowupList = await InquiryRepo.getAllInquiryFollowups();

      final selectedInquiryFollowupList = inquiryFollowupList
          .where((element) => element.inquiryId == int.parse(inquiryId))
          .toList();
      showlog(
        "inquiryFollowupList : ${selectedInquiryFollowupList.map((e) => e.toJson()).toList()}",
      );
      await convertInquiryFollowupToQuotationFollowup(
        selectedInquiryFollowupList,
      );
    } catch (e) {
      showlog("Error converting inquiry to quotation: $e");
    }
  }

  //convert inq customer to quotation customer
  static Future<void> convertInquiryCustomerToQuotationCustomer(
    InquiryModel inquiry,
  ) async {
    try {
      final quotation = QuotationModel(
        uid: inquiry.uid,
        custId: inquiry.custId,
        custName1: inquiry.custName1,
        custName2: inquiry.custName2,
        date: inquiry.date,
        email: inquiry.email,
        mobileNo: inquiry.mobileNo,
        source: inquiry.source,
        isSynced: inquiry.isSynced,
      );
      await QuotationRepo.insertQuotation(quotation);
    } catch (e) {
      showlog("error converting customer to quotation : $e");
    }
  }

  //convert inq product to quotation product
  static Future<void> convertInquiryProductToQuotationProduct(
    List<InquiryProductModel> inquiryProduct,
  ) async {
    try {
      for (var inquiryProduct in inquiryProduct) {
        final quotationProduct = QuotationProductModel(
          quotationId: inquiryProduct.inquiryId,
          productId: inquiryProduct.productId,
          quantity: inquiryProduct.quantity,
          remark: inquiryProduct.remark,
        );
        await QuotationRepo.insertQuotationProduct(quotationProduct);
      }
    } catch (e) {
      showlog("Error converting inquiry product to quotation product: $e");
    }
  }

  static Future<void> convertInquiryFollowupToQuotationFollowup(
    List<InquiryFollowupModel> inquiryFollowup,
  ) async {
    try {
      for (var inquiryFollowup in inquiryFollowup) {
        final quotationFollowup = QuotationFollowupModel(
          quotationId: inquiryFollowup.inquiryId,
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
      showlog("Error converting inquiry followup to quotation followup: $e");
    }
  }
}

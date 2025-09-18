import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/inquiry/model/inquiry_model.dart';
import 'package:crm/screen/inquiry/model/inquiry_product_model.dart';
import 'package:crm/screen/inquiry/repo/inquiry_repo.dart';
import 'package:crm/screen/product/model/product_model.dart';
import 'package:crm/screen/product/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    // Set initial inquiry number based on the total number of inquiries
    controllers['num']!.text = (inquiryList.length + 1).toString();
    controllers['date']!.text = dateFormat.format(DateTime.now());
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
    final quntityText = controllers["quntity"]!.text;
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
      inquiryProductList.assignAll(result);
      showlog(
        "inquiry product list : ${result.map((e) => e.toJson()).toList()}",
      );
    } catch (e) {
      showlog("error on get product list : $e");
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
      customerList.forEach((key, value) => showlog("$key : $value"));
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
      final inqProdId = InquiryProductModel(
        inquiryId: inquiryList.length + 1,
        productId: getProductId(selectedProduct!.value),
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
      // await addProduct(); // product
      await addInquiryProductID(); // both's id
    } catch (e) {
      showlog("Error submitting inquiry : $e");
    }
  }
}

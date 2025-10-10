import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_snackbars.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/masters/product/model/product_model.dart';
import 'package:crm/screen/masters/product/repo/product_repo.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/screen/masters/uom/repo/uom_repo.dart';
import 'package:crm/screen/orders/models/order_invoice_model.dart';
import 'package:crm/screen/orders/models/order_model.dart';
import 'package:crm/screen/orders/models/order_product_model.dart';
import 'package:crm/screen/orders/models/order_terms_model.dart';
import 'package:crm/screen/orders/repo/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  RxString? selectedProduct = RxString("");
  RxString? selectedUOM = RxString("");

  final RxList<OrderModel> orderList = <OrderModel>[].obs;
  final RxList<OrderModel> filterendList = <OrderModel>[].obs;
  RxList<TermsModel> allTerms = <TermsModel>[].obs;
  RxList<OrderTermsModel> orderTermsList = <OrderTermsModel>[].obs;
  RxList<int> selectedTerms = <int>[].obs;
  var customerList = <String, String>{}.obs;
  var selectedCustomer = "".obs;
  var productList = <ProductModel>[].obs;
  RxList<OrderProductModel> orderProductList = <OrderProductModel>[].obs;
  var uomList = <UomModel>[].obs;

  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};

  bool isEdit = false;
  String? no;
  final dateFormat = DateFormat("d/M/yyyy");

  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      isEdit = args['isEdit'] ?? false;
      // selectedOrder = args['selectedOrder'];
    }

    _initializeControllersAndFocusNodes();
    await getOrderList();
    await getProductList();
    await getOrderProductList();
    await getCustomersList();
    await getAllTerms();
    await getUomList();

    // Set initial quotation number based on the total number of quotations
    if (isEdit) {
      await setEditDetails();
    } else if (controllers['num']?.text.isEmpty ?? true) {
      controllers['num']!.text = (await OrderRepo().getNextOrderId())
          .toString();

      showlog("Order -- Last id in controller : ${controllers['num']!.text}");

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
      "quantity",
      "rate",
      "amount",
      "discount",
      "remarks",
      "termsAndConditions",
      "supplier_ref",
      "other_ref",
      "extra_discount",
      "freight_amount",
      "loading_charges",
    ];

    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
  }

  void updateOrderTermsList() {
    if (selectedTerms.isEmpty) {
      orderTermsList.clear();
      return;
    }

    // Efficiently find all selected terms without nested loops
    final selectedTermModels = allTerms
        .where((term) => selectedTerms.contains(term.id))
        .toList();

    orderTermsList.value = selectedTermModels.map((term) {
      return OrderTermsModel(
        orderId: int.parse(controllers['num']!.text),
        termId: term.id,
      );
    }).toList();
  }

  void updateUOM(String? val) {
    if (val != null) selectedUOM?.value = val;
  }

  // @override
  // void onClose() {
  //   _disposeControllersAndFocusNodes();
  //   super.onClose();
  // }

  // void _disposeControllersAndFocusNodes() {
  //   controllers.forEach((key, controller) => controller.dispose());
  //   focusNodes.forEach((key, focusNode) => focusNode.dispose());
  // }

  Future<void> setEditDetails() async {
    int intNo = int.parse(no ?? '');

    controllers['num']!.text = no!;
    controllers['date']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .date!;
    controllers['name1']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    selectedCustomer.value = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .custName1!;
    controllers['email']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .email!;
    controllers['mobile']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .mobileNo!;
    controllers['social']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .source!;
    controllers['supplier_ref']!.text =
        orderList
            .firstWhereOrNull((element) => element.id == intNo)!
            .supplierRef ??
        '';
    controllers['other_ref']!.text =
        orderList
            .firstWhereOrNull((element) => element.id == intNo)!
            .otherRef ??
        '';
    controllers['extra_discount']!.text = orderList
        .firstWhereOrNull((element) => element.id == intNo)!
        .extraDiscount
        .toString();
    controllers['freight_amount']!.text =
        orderList
            .firstWhereOrNull((element) => element.id == intNo)!
            .freightAmount ??
        '';
    controllers['loading_charges']!.text =
        orderList
            .firstWhereOrNull((element) => element.id == intNo)!
            .loadingCharges ??
        '';
    await getOrderProductList();
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

  /// Search for customer name or number
  void searchResult(String val) {
    showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = orderList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = orderList.where((item) {
      final custName = item.custName1?.toLowerCase();
      final uid = item.uid
          ?.toLowerCase(); // Assuming uid is a string or can be converted to one

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid?.contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  ///get all product list
  Future<void> getProductList() async {
    try {
      final result = await ProductRepo.getAllProducts();
      productList.assignAll(result);
    } catch (e) {
      showlog("error on get product list : $e");
    }
  }

  Future<void> getUomList() async {
    try {
      final result = await UomRepo.getAllUom();
      uomList.assignAll(result);
      showlog("uom list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("Error getting UOM list : $e");
    }
  }

  /// get order product list
  Future<void> getOrderProductList() async {
    try {
      final result = await OrderRepo.getAllOrderProducts();
      showlog(
        "getOrderProductList result : ${result.map((e) => e.toJson()).toList()}",
      );
      orderProductList.assignAll(
        result
            .where(
              (element) =>
                  element.orderId == int.tryParse(controllers['num']!.text),
            )
            .toList(),
      );
      showlog("order product list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("error on get order product list : $e");
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

  /// get order list
  Future<void> getOrderList() async {
    try {
      final result = await OrderRepo.getAllOrders();
      orderList.assignAll(result);
      filterendList.value = orderList;
      showlog("order list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("error on get order list : $e");
    }
  }

  ///add Customer
  Future<void> addOrderCustomer() async {
    try {
      final custName = selectedCustomer.value;
      final custId = customerList[custName];

      showlog("custName : $custName");
      showlog("custId : $custId");

      final orderCustomer = OrderModel(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        custId: int.parse(custId ?? ''),
        custName1: selectedCustomer.value,
        custName2: controllers["name2"]!.text,
        date: controllers["date"]!.text,
        email: controllers["email"]!.text,
        mobileNo: controllers["mobile"]!.text,
        source: controllers["social"]!.text,
        supplierRef: controllers["supplier_ref"]!.text,
        otherRef: controllers["other_ref"]!.text,
        extraDiscount: double.parse(controllers["extra_discount"]!.text),
        freightAmount: controllers["freight_amount"]!.text,
        loadingCharges: controllers["loading_charges"]!.text,
      );

      showlog("added order customer ----> ${orderCustomer.toJson()}");

      int result = await OrderRepo.insertOrder(orderCustomer);
      // showSuccessSnackBar("Customer added successfully");
      showlog("insert order customer ----> $result");
      await getOrderList();
    } catch (e) {
      // showErrorSnackBar("Error adding customer $e");
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

  ///add order & product id to table so we have track of for a customer how many products order we have
  /*  Future<void> addOrderProductID() async {
    try {
      final orderId = int.parse(controllers['num']!.text);
      final orderProdId = OrderProductModel(
        orderId: orderId,
        productId: getProductId(selectedProduct!.value),
        quantity: int.parse(controllers["quantity"]!.text),
        discount: double.parse(controllers['discount']!.text),
        remark: controllers['remarks']!.text,
      );

      showlog("quotation id : ${orderProdId.orderId}");
      showlog("product id : ${orderProdId.productId}");

      int result = await OrderRepo.insertOrderProduct(orderProdId);
      showlog("insert order product ----> $result");
      showSuccessSnackBar("Product added successfully");
      await getOrderProductList();
    } catch (e) {
      showErrorSnackBar("Error adding product: $e");
      showlog("Error adding product & quotation ID : $e");
    }
  }
*/

  RxList<OrderProductModel> tempProductList = <OrderProductModel>[].obs;

  void addtempProductList() {
    final orderId = int.parse(controllers['num']!.text);
    showlog("order id in temp list : $orderId");

    try {
      tempProductList.add(
        OrderProductModel(
          orderId: orderId,
          productId: getProductId(selectedProduct!.value),
          quantity: int.parse(controllers["quantity"]!.text),
          discount: double.parse(controllers['discount']!.text),
          remark: controllers['remarks']!.text,
        ),
      );

      orderProductList.addAll(tempProductList);

      showSuccessSnackBar("Product added successfully");
    } catch (e) {
      showErrorSnackBar("Error adding product: $e");
      showlog("Error adding product & quotation ID : $e");
    }
  }

  Future<void> addOrderProduct() async {
    try {
      for (var product in orderProductList) {
        int result = await OrderRepo.insertOrderProduct(product);
        showlog("insert order product ----> $result");
      }
    } catch (e) {
      showErrorSnackBar("Error adding product");
      showlog("Error adding product : $e");
    }
  }

  ///save order
  Future<void> submitQuotation() async {
    try {
      await addOrderCustomer();
      await getOrderList();
      showSuccessSnackBar("Order submitted successfully");
    } catch (e) {
      showErrorSnackBar("Error submitting order : $e");
      showlog("Error submitting order : $e");
    }
  }

  Future<void> deleteOrder({required int id}) async {
    try {
      await OrderRepo.deleteOrder(id);
      await getOrderList();
      await OrderRepo.deleteOrderProduct(id);
      await getOrderProductList();
      showSuccessSnackBar("Order deleted successfully");
    } catch (e) {
      showErrorSnackBar("Error deleting order : $e");
      showlog("Error deleting order : $e");
    }
  }

  Future<void> updateOrder() async {
    try {
      //FIXME: implement update logic
      /* 
      If we re getting contact details & product details from their different masters
      What we need to update ????
      */
      final order = OrderModel(
        id: int.parse(controllers['num']!.text),
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        custId: int.parse(controllers['custId']!.text),
        custName1: selectedCustomer.value,
        custName2: controllers['name2']!.text,
        date: controllers['date']!.text,
        email: controllers['email']!.text,
        mobileNo: controllers['mobile']!.text,
        source: controllers['social']!.text,
        supplierRef: controllers['supplier_ref']!.text,
        otherRef: controllers['other_ref']!.text,
        extraDiscount: double.parse(controllers['extra_discount']!.text),
        freightAmount: controllers['freight_amount']!.text,
        loadingCharges: controllers['loading_charges']!.text,
      );
      showlog("update order ----> ${order.toJson()}");
      // int result = await QuotationRepo.updateQuotation(quotation);
      showSuccessSnackBar("Order updated successfully");
      // showlog("updated quotation ----> $result");
    } catch (e) {
      showErrorSnackBar("Error updating order : $e");
      showlog("Error update order : $e");
    }
  }

  // ----- order terms ------

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
  Future<void> getSelectedTerms(int? orderId) async {
    try {
      showlog("Quotation ID: $orderId");
      final result = await OrderRepo.getSelectedTerms(orderId!);
      showlog("selected terms : ${result.map((e) => e.toJson()).toList()}");
      orderTermsList.assignAll(result);

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
    updateOrderTerms();
  }

  /// Helper method to rebuild the quotation list
  void updateOrderTerms() {
    // Find all the full TermModels that are currently selected
    final selectedTermModels = allTerms.where((term) {
      return selectedTerms.contains(term.id);
    });

    // Map these models to the QuotationTermsModel
    orderTermsList.value = selectedTermModels.map((term) {
      return OrderTermsModel(
        orderId: int.parse(controllers['num']!.text),
        termId: term.id,
      );
    }).toList();

    showlog("Selected Terms: ${selectedTerms.toList()}");
  }

  // add new selected term
  Future<void> addOrderTerms(int orderId) async {
    try {
      showlog("add quote term : Order ID --> $orderId");
      showlog(
        "Quotation Term List : ${orderTermsList.map((e) => e.toJson()).toList()}",
      );
      for (var term in orderTermsList) {
        final orderTerms = OrderTermsModel(
          orderId: orderId,
          termId: term.termId,
        );
        showlog("added Order terms ----> ${orderTerms.toJson()}");
        int result = await OrderRepo.insertOrderTerms(orderTerms);
        showlog("insert Order terms ----> $result");
      }
      showSuccessSnackBar("Order terms added successfully");
    } catch (e) {
      showErrorSnackBar("Error adding Order terms : $e");
      showlog("Error adding Order terms : $e");
    }
  }

  // ------------------------------------------------------------------------------------------
  //-------------------- MARK: Invoice
  // ------------------------------------------------------------------------------------------

  final invoiceCustName = "".obs;
  final invoiceCustContact = "".obs;
  final invoiceCustEmail = "".obs;
  final extraDiscount = "".obs;
  final freightAmount = "".obs;
  final loadingCharges = "".obs;
  final suppRef = "".obs;
  final otherRef = "".obs;
  final invoiceProductList = <ProductItem>[].obs;
  final invoiceTermsList = <OrderTermsModel>[].obs;

  Future<OrderInvoiceModel> setOrderInvoiceDetails(String orderId) async {
    try {
      showlog("order ID : $orderId");
      final currentOrder = await OrderRepo.getOrderById(orderId);
      showlog("contact id : ${currentOrder.custId}");
      final customerDetails = await ContactsRepo.getContactById(
        currentOrder.custId.toString(),
      );

      invoiceCustName.value = currentOrder.custName1 ?? '';
      invoiceCustContact.value = customerDetails.mobileNo ?? '';
      invoiceCustEmail.value = customerDetails.email ?? '';
      extraDiscount.value = currentOrder.extraDiscount.toString();
      freightAmount.value = currentOrder.freightAmount ?? '0';
      loadingCharges.value = currentOrder.loadingCharges ?? '0';
      suppRef.value = currentOrder.supplierRef ?? '';
      otherRef.value = currentOrder.otherRef ?? '';

      final productList = await OrderRepo.getAllOrderProducts();

      final selectedProductList = productList
          .where((element) => element.orderId == int.parse(orderId))
          .toList();

      List<ProductItem> productItems = [];
      invoiceProductList.value = productItems;

      //get selected product details from product repo
      final allProducts = await ProductRepo.getAllProducts();

      for (var product in selectedProductList) {
        productItems.add(
          ProductItem(
            qty: product.quantity,
            rate: product.discount,
            amount: 0,
            itemName: allProducts
                .where((e) => e.productId == product.productId)
                .first
                .productName,
            altAmt: 0,
            disc1: 0,
            disc2: 0,
          ),
        );
      }

      final selectedTerms = await OrderRepo.getSelectedTerms(
        int.parse(orderId),
      );
      invoiceTermsList.value = selectedTerms;

      final orderInvoice = OrderInvoiceModel(
        custName: invoiceCustName.value,
        custContact: invoiceCustContact.value,
        custEmail: invoiceCustEmail.value,
        extraDiscount: double.parse(extraDiscount.value),
        freightAmount: double.parse(freightAmount.value),
        loadCharges: double.parse(loadingCharges.value),
        supplierRef: suppRef.value,
        otherRef: otherRef.value,
      );

      return orderInvoice;
    } catch (e) {
      showlog("Error setting order invoice details : $e");
      rethrow;
    }
  }
}

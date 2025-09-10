import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/model/contact_model.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerController extends GetxController {
  RxBool isLoading = false.obs;

  /// Store text controllers & focus nodes in maps
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  final RxList<ContactModel> contacts = <ContactModel>[].obs;
  final RxList<ContactModel> filterendList = <ContactModel>[].obs;

  /// Dropdown values
  RxString? selectedBusinessType = RxString("");
  RxString? selectedIndustryType = RxString("");
  RxString? selectedDesignationType = RxString("");
  RxString? selectedDepartmentType = RxString("");

  /// Radio button value
  RxString radioValue = "active".obs;

  final List<String> fields = [
    "name",
    "address",
    "city",
    "state",
    "district",
    "country",
    "pincode",
    "mobile",
    "email",
    "website",
    "businessType",
    "industryType",
    //contact fields
    "contactName",
    "contactPhoneNo",
    "contactMobileNo",
    "contactEmail",
    "department",
    "designation",
  ];

  @override
  void onInit() async {
    super.onInit();
    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
    await getAllContacts();
  }

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    super.onClose();
  }

  /// Update dropdowns
  void updateBusinessType(String? val) {
    if (val != null) selectedBusinessType?.value = val;
  }

  void updateIndustryType(String? val) {
    if (val != null) selectedIndustryType?.value = val;
  }

  void updateDesignationType(String? val) {
    if (val != null) selectedDesignationType?.value = val;
  }

  void updateDepartmentType(String? val) {
    if (val != null) selectedDepartmentType?.value = val;
  }

  /// Radio button change
  void updateRadio(String? val) {
    if (val != null) radioValue.value = val;
  }

  ///search for customername
  // void searchCustomerResult(String val) {
  //   showlog("search for customer name : $val");
  //   filterendList.value = AppFunctions.searchList(
  //     val,
  //     contacts,
  //     (item) => item.custName,
  //   );
  // }

  // ///search for number
  // void searchNumResult(String val) {
  //   showlog("search for number : $val");
  //   filterendList.value = AppFunctions.searchList(
  //     val,
  //     contacts,
  //     (item) => item.uid,
  //   );
  // }

  /// Search for customer name or number
  void searchResult(String val) {
    showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = contacts;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = contacts.where((item) {
      final custName = item.custName?.toLowerCase();
      final uid = item.uid
          ?.toLowerCase(); // Assuming uid is a string or can be converted to one

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid?.contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  //--------- DB operations -----------------\\

  ///get all customer data
  Future<void> getAllContacts() async {
    final result = await ContactsRepo.getAllContacts();
    contacts.value = result;
    filterendList.assignAll(contacts);
    showlog("contacts : ${contacts.length}");
  }

  ///get user by id for edit
  Future<ContactModel> getContactById(String uid) async {
    return await ContactsRepo.getContactById(uid);
  }

  /// Update existing customer
  Future<void> updateContact(ContactModel contact) async {
    contact.custName = controllers["name"]!.text;
    contact.address = controllers["address"]!.text;
    contact.city = controllers["city"]!.text;
    contact.state = controllers["state"]!.text;
    contact.district = controllers["district"]!.text;
    contact.country = controllers["country"]!.text;
    contact.pincode = controllers["pincode"]!.text;
    contact.mobileNo = controllers["mobile"]!.text;
    contact.email = controllers["email"]!.text;
    contact.website = controllers["website"]!.text;
    contact.businessType = controllers["businessType"]!.text;
    contact.industryType = controllers["industryType"]!.text;
    contact.status = radioValue.value;
    contact.contactName = controllers["contactName"]!.text;
    contact.department = selectedDepartmentType?.value;
    contact.designation = selectedDesignationType?.value;
    contact.contEmail = controllers["contactEmail"]!.text;
    contact.contPhoneNo = controllers["contactPhoneNo"]!.text;
    contact.contMobileNo = controllers["contactMobileNo"]!.text;
    await ContactsRepo.updateContact(contact);
    await getAllContacts();
    isLoading.value = false;
    Get.back();
  }

  ///add new customer
  Future<void> addContact() async {
    final contact = ContactModel(
      uid: DateTime.now().millisecondsSinceEpoch
          .toString(), // change to actual id
      custName: controllers["name"]!.text,
      address: controllers["address"]!.text,
      city: controllers["city"]!.text,
      state: controllers["state"]!.text,
      district: controllers["district"]!.text,
      country: controllers["country"]!.text,
      pincode: controllers["pincode"]!.text,
      mobileNo: controllers["mobile"]!.text,
      email: controllers["email"]!.text,
      website: controllers["website"]!.text,
      businessType: controllers["businessType"]!.text,
      industryType: controllers["industryType"]!.text,
      status: radioValue.value,
      contactName: controllers["contactName"]!.text,
      department: selectedDepartmentType?.value,
      designation: selectedDesignationType?.value,
      contEmail: controllers["email"]!.text,
      contPhoneNo: controllers["contactPhoneNo"]!.text,
      contMobileNo: controllers["contactMobileNo"]!.text,
    );

    showlog("new contact : ${contact.toJson()}");

    await ContactsRepo.insertContact(contact);
    await getAllContacts();
    Get.back();
  }
}

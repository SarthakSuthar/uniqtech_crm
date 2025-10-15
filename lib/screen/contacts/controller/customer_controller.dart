import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/contacts/model/contact_model.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/login/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCustomerController extends GetxController {
  RxBool isLoading = false.obs;

  bool isEdit = false;
  String? no;
  final dateFormat = DateFormat("d/M/yyyy");

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

    // if (isEdit) {
    //   await setEditValues();
    // }
    await getAllContacts();
    await loadUserId();
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

  Future<void> setEditValues() async {
    isLoading.value = true;

    final intNo = int.parse(no ?? '');
    final contactToEdit = contacts.firstWhereOrNull(
      (element) => element.id == intNo,
    );

    if (contactToEdit != null) {
      controllers['name']!.text = contactToEdit.custName ?? '';
      controllers['address']!.text = contactToEdit.address ?? '';
      controllers['city']!.text = contactToEdit.city ?? '';
      controllers['state']!.text = contactToEdit.state ?? '';
      controllers['district']!.text = contactToEdit.district ?? '';
      controllers['country']!.text = contactToEdit.country ?? '';
      controllers['pincode']!.text = contactToEdit.pincode ?? '';
      controllers['mobile']!.text = contactToEdit.mobileNo ?? '';
      controllers['email']!.text = contactToEdit.email ?? '';
      controllers['website']!.text = contactToEdit.website ?? '';
      controllers['businessType']!.text = contactToEdit.businessType ?? '';
      controllers['industryType']!.text = contactToEdit.industryType ?? '';
      controllers['contactName']!.text = contactToEdit.contactName ?? '';
      controllers['contactPhoneNo']!.text = contactToEdit.contPhoneNo ?? '';
      controllers['contactMobileNo']!.text = contactToEdit.contMobileNo ?? '';
      controllers['contactEmail']!.text = contactToEdit.contEmail ?? '';
      selectedBusinessType?.value = contactToEdit.businessType ?? '';
      selectedDepartmentType?.value = contactToEdit.department ?? '';
      selectedDesignationType?.value = contactToEdit.designation ?? '';
      selectedIndustryType?.value = contactToEdit.industryType ?? '';
    }
  }

  /// Search for customer name or number
  void searchResult(String val) {
    AppUtils.showlog("search for name or number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filterendList.value = contacts;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filterendList.value = contacts.where((item) {
      final custName = item.custName?.toLowerCase();
      final uid = item.id
          .toString()
          .toLowerCase(); // Assuming uid is a string or can be converted to one

      // An item is a match if its name OR uid contains the search query
      return (custName?.contains(lowerCaseQuery) ?? false) ||
          (uid.contains(lowerCaseQuery));
    }).toList();
  }

  //--------- DB operations -----------------\\

  ///get all customer data
  Future<void> getAllContacts() async {
    final result = await ContactsRepo.getAllContacts();
    contacts.value = result;
    filterendList.assignAll(contacts);
    AppUtils.showlog("No. of contacts : ${contacts.length}");
    AppUtils.showlog(
      "Contacts details ---> ${contacts.map((e) => 'id: ${e.id}, isSynced: ${e.isSynced}').toList()}",
    );
  }

  ///delete contact
  Future<void> deleteContact(String id) async {
    await ContactsRepo.deleteContact(int.parse(id));
    filterendList.remove(ContactModel(id: int.parse(id)));
    contacts.remove(ContactModel(id: int.parse(id)));

    AppUtils.showlog("removed contact : $id");
    AppUtils.showlog("No. of contacts : ${contacts.length}");
    AppUtils.showlog("list after removing --> ${contacts.map((e) => e.id)}}");
  }

  ///get user by id for edit
  Future<ContactModel> getContactById(String uid) async {
    return await ContactsRepo.getContactById(uid);
  }

  String? uid;

  Future<void> loadUserId() async {
    try {
      uid = await UserRepo.getUserId();
      AppUtils.showlog("uid in customer controller : $uid");
    } catch (e) {
      AppUtils.showlog("error in customer controller : $e");
    }
  }

  /// Update existing customer
  Future<void> updateContact(ContactModel contact) async {
    contact.updatedBy = uid;
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
    contact.updatedAt = DateTime.now().toString();
    contact.isSynced = 0;

    await ContactsRepo.updateContact(contact);
    await getAllContacts();
    isLoading.value = false;
    Get.back();
  }

  ///add new customer
  Future<void> addContact() async {
    final contact = ContactModel(
      createdBy: uid,
      updatedBy: uid,
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
      createdAt: DateTime.now().toString(), //YYYY-MM-DD hh:mm:ss.ms --> formate
      updatedAt: DateTime.now().toString(),
    );

    AppUtils.showlog("new contact : ${contact.toJson()}");

    await ContactsRepo.insertContact(contact);
    await getAllContacts();
    Get.back();
  }
}

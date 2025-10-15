import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/contacts/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerContactScreen extends StatefulWidget {
  final String uid;
  final bool isEdit;
  const AddCustomerContactScreen({
    super.key,
    required this.uid,
    required this.isEdit,
  });

  @override
  State<AddCustomerContactScreen> createState() =>
      _AddCustomerContactScreenState();
}

class _AddCustomerContactScreenState extends State<AddCustomerContactScreen> {
  final AddCustomerController controller = Get.find<AddCustomerController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      controller.getContactById(widget.uid).then((contact) {
        controller.controllers["contactName"]!.text = contact.contactName ?? '';
        controller.selectedDepartmentType?.value = contact.department ?? '';
        controller.selectedDesignationType?.value = contact.designation ?? '';
        controller.controllers["contactEmail"]!.text = contact.contEmail ?? '';
        controller.controllers["contactPhoneNo"]!.text =
            contact.contPhoneNo ?? '';
        controller.controllers["contactMobileNo"]!.text =
            contact.contMobileNo ?? '';
      });

      AppUtils.showlog("uid: ${widget.uid}");
      AppUtils.showlog(
        "contactName: ${controller.controllers["contactName"]!.text}",
      );
    }
  }

  // @override
  // void dispose() {
  //   // Dispose all text controllers
  //   controller.controllers.forEach((key, value) {
  //     value.dispose();
  //   });
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.focusNodes.forEach((_, node) => node.unfocus()),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputWidget(
                hintText: "Contact Name",
                icon: Icons.person,
                controller: controller.controllers["contactName"]!,
                context: context,
                focusNode: controller.focusNodes["contactName"]!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Obx(
                      () => dropdownWidget(
                        hintText: "Department",
                        icon: Icons.business,
                        items: ["Retail", "Wholesale", "Service"],
                        value:
                            controller.selectedDepartmentType?.value.isEmpty ==
                                true
                            ? null
                            : controller.selectedDepartmentType!.value,
                        onChanged: controller.updateDepartmentType,
                        expandInRow: true,
                      ),
                    ),
                    Obx(
                      () => dropdownWidget(
                        hintText: "Designation",
                        icon: Icons.business,
                        items: ["Retail", "Wholesale", "Service"],
                        value:
                            controller.selectedDesignationType?.value.isEmpty ==
                                true
                            ? null
                            : controller.selectedDesignationType!.value,
                        onChanged: controller.updateDesignationType,
                        expandInRow: true,
                      ),
                    ),
                  ],
                ),
              ),
              inputWidget(
                hintText: "Email",
                icon: Icons.person,
                controller: controller.controllers["contactEmail"]!,
                context: context,
                focusNode: controller.focusNodes["contactEmail"]!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    inputWidget(
                      hintText: "Phone No",
                      icon: Icons.person,
                      controller: controller.controllers["contactPhoneNo"]!,
                      context: context,
                      focusNode: controller.focusNodes["contactPhoneNo"]!,
                      expandInRow: true,
                    ),
                    inputWidget(
                      hintText: "Mobile No",
                      icon: Icons.person,
                      controller: controller.controllers["contactMobileNo"]!,
                      context: context,
                      focusNode: controller.focusNodes["contactMobileNo"]!,
                      expandInRow: true,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buttonWidget(
                    title: widget.isEdit ? "Update" : "ADD",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        ); // Show loading dialog
                        try {
                          widget.isEdit
                              ? await controller.updateContact(
                                  await controller.getContactById(widget.uid),
                                )
                              : await controller.addContact();
                        } finally {
                          Get.back(); // Dismiss loading dialog
                        }
                      }
                    },
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

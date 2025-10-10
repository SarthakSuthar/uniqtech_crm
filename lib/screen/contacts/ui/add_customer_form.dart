import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/contacts/controller/customer_controller.dart';

class AddCustomerForm extends StatefulWidget {
  final String uid;
  final bool isEdit;
  const AddCustomerForm({super.key, required this.uid, required this.isEdit});

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final AddCustomerController controller = Get.put(AddCustomerController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      controller.getContactById(widget.uid).then((contact) {
        controller.controllers["name"]!.text = contact.custName ?? '';
        controller.controllers["address"]!.text = contact.address ?? '';
        controller.controllers["city"]!.text = contact.city ?? '';
        controller.controllers["state"]!.text = contact.state ?? '';
        controller.controllers["district"]!.text = contact.district ?? '';
        controller.controllers["country"]!.text = contact.country ?? '';
        controller.controllers["pincode"]!.text = contact.pincode ?? '';
        controller.controllers["mobile"]!.text = contact.mobileNo ?? '';
        controller.controllers["email"]!.text = contact.email ?? '';
        controller.controllers["website"]!.text = contact.website ?? '';
        controller.controllers["businessType"]!.text =
            contact.businessType ?? '';
        controller.controllers["industryType"]!.text =
            contact.industryType ?? '';
        controller.radioValue.value = contact.status!;
      });
    }
  }

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
                hintText: "Customer Name",
                icon: Icons.person,
                controller: controller.controllers["name"]!,
                context: context,
                focusNode: controller.focusNodes["name"]!,
              ),
              inputWidget(
                hintText: "Address",
                icon: Icons.location_pin,
                controller: controller.controllers["address"]!,
                context: context,
                focusNode: controller.focusNodes["address"]!,
                minLines: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    inputWidget(
                      hintText: "City",
                      icon: Icons.home,
                      controller: controller.controllers["city"]!,
                      context: context,
                      focusNode: controller.focusNodes["city"]!,
                      expandInRow: true,
                    ),
                    inputWidget(
                      hintText: "State",
                      icon: Icons.location_pin,
                      controller: controller.controllers["state"]!,
                      context: context,
                      focusNode: controller.focusNodes["state"]!,
                      expandInRow: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    inputWidget(
                      hintText: "District",
                      icon: Icons.location_city,
                      controller: controller.controllers["district"]!,
                      context: context,
                      focusNode: controller.focusNodes["district"]!,
                      expandInRow: true,
                    ),
                    inputWidget(
                      hintText: "Country",
                      icon: Icons.language,
                      controller: controller.controllers["country"]!,
                      context: context,
                      focusNode: controller.focusNodes["country"]!,
                      expandInRow: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    inputWidget(
                      hintText: "Pincode",
                      icon: Icons.label,
                      controller: controller.controllers["pincode"]!,
                      context: context,
                      focusNode: controller.focusNodes["pincode"]!,
                      keyboardType: TextInputType.number,
                      expandInRow: true,
                    ),
                    inputWidget(
                      hintText: "Mobile No",
                      icon: Icons.phone,
                      controller: controller.controllers["mobile"]!,
                      context: context,
                      focusNode: controller.focusNodes["mobile"]!,
                      keyboardType: TextInputType.phone,
                      expandInRow: true,
                    ),
                  ],
                ),
              ),
              inputWidget(
                hintText: "Email",
                icon: Icons.email,
                controller: controller.controllers["email"]!,
                context: context,
                focusNode: controller.focusNodes["email"]!,
                keyboardType: TextInputType.emailAddress,
              ),
              inputWidget(
                hintText: "Website",
                icon: Icons.web,
                controller: controller.controllers["website"]!,
                context: context,
                focusNode: controller.focusNodes["website"]!,
                keyboardType: TextInputType.url,
              ),

              inputWidget(
                hintText: "Enter Business Type",
                icon: Icons.business,
                controller: controller.controllers["businessType"]!,
                context: context,
                focusNode: controller.focusNodes["businessType"]!,
                keyboardType: TextInputType.url,
              ),

              inputWidget(
                hintText: "Enter Industry Type",
                icon: Icons.business,
                controller: controller.controllers["industryType"]!,
                context: context,
                focusNode: controller.focusNodes["industryType"]!,
                keyboardType: TextInputType.url,
              ),

              // Radio
              Obx(
                () => Row(
                  children: [
                    Text(
                      "Status",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Radio(
                      value: "active",
                      groupValue: controller.radioValue.value,
                      onChanged: controller.updateRadio,
                    ),
                    const Text("Active"),
                    Radio(
                      value: "inactive",
                      groupValue: controller.radioValue.value,
                      onChanged: controller.updateRadio,
                    ),
                    const Text("Inactive"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              widget.isEdit == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buttonWidget(
                          title: "Update",
                          context: context,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              controller.isLoading = true.obs;
                              await controller.updateContact(
                                await controller.getContactById(widget.uid),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buttonWidget(
                          title: "NEXT",
                          context: context,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              DefaultTabController.of(context).animateTo(1);
                            }
                          },
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

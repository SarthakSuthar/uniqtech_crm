import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_const/utils/app_utils.dart';

class AddQuoteCustomer extends StatefulWidget {
  const AddQuoteCustomer({super.key, this.no, required this.isEdit});

  final String? no;
  final bool isEdit;

  @override
  State<AddQuoteCustomer> createState() => _AddQuoteCustomerState();
}

class _AddQuoteCustomerState extends State<AddQuoteCustomer> {
  final QuotesController controller = Get.put(QuotesController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.isEdit ? controller.isEdit = true : controller.isEdit = false;
    widget.no != null ? controller.no = widget.no : controller.no = '';
  }

  @override
  Widget build(BuildContext context) {
    // widget.isEdit == true
    //     ? controller.isEdit = true
    //     : controller.isEdit = false;
    // widget.no != null ? controller.no = widget.no : controller.no = '';

    AppUtils.showlog("isEdit -----> ${controller.isEdit}");
    AppUtils.showlog("no -----> ${controller.no}");

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<QuotesController>();
          AppUtils.showlog("Route popped with result: $result");
        } else {
          AppUtils.showlog("Pop prevented!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () =>
              controller.focusNodes.forEach((_, node) => node.unfocus()),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      inputWidget(
                        hintText: "number",
                        icon: Icons.numbers,
                        controller: controller.controllers["num"]!,
                        context: context,
                        focusNode: controller.focusNodes["num"]!,
                        expandInRow: true,
                      ),
                      datePickerWidget(
                        icon: Icons.date_range,
                        controller: controller.controllers["date"]!,
                        context: context,
                        expandInRow: true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => dropdownWidget(
                          hintText: "Select Customer",
                          icon: Icons.person,
                          items: controller.customerList.keys.toList(),
                          value:
                              controller.selectedCustomer.value.isEmpty == true
                              ? null
                              : controller.selectedCustomer.value,
                          onChanged: (value) {
                            controller.selectedCustomer.value = value!;
                            controller.getSelectedContactDetails(value);
                          },
                          expandInRow: true,
                        ),
                      ),
                      //Go to add customer page
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(14.0),
                      //     child: Icon(Icons.add),
                      //   ),
                      // ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     inputWidget(
                  //       hintText: "Name",
                  //       icon: Icons.person,
                  //       controller: controller.controllers["name2"]!,
                  //       context: context,
                  //       focusNode: controller.focusNodes["name2"]!,
                  //       expandInRow: true,
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(14.0),
                  //         child: Icon(Icons.add),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  inputWidget(
                    hintText: "Email",
                    icon: Icons.email,
                    controller: controller.controllers["email"]!,
                    context: context,
                    focusNode: controller.focusNodes["email"]!,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Row(
                    children: [
                      inputWidget(
                        hintText: "Mobile No",
                        icon: Icons.phone,
                        controller: controller.controllers["mobile"]!,
                        context: context,
                        focusNode: controller.focusNodes["mobile"]!,
                        keyboardType: TextInputType.phone,
                        expandInRow: true,
                      ),
                      inputWidget(
                        hintText: "Social",
                        icon: Icons.person,
                        controller: controller.controllers["social"]!,
                        context: context,
                        focusNode: controller.focusNodes["social"]!,
                        expandInRow: true,
                      ),
                    ],
                  ),

                  inputWidget(
                    hintText: "Subject",
                    icon: Icons.subject,
                    controller: controller.controllers["subject"]!,
                    context: context,
                    focusNode: controller.focusNodes["subject"]!,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonWidget(
                        title: "Next",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            DefaultTabController.of(context).animateTo(1);
                          }
                          AppUtils.showlog("Next :: Add inquirt customer");
                        },
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

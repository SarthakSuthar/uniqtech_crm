import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_const/utils/app_utils.dart';

class AddQuoteCustomer extends StatelessWidget {
  AddQuoteCustomer({super.key, this.no, required this.isEdit});

  final String? no;
  final bool isEdit;

  final QuotesController controller = Get.put(QuotesController());

  @override
  Widget build(BuildContext context) {
    isEdit == true ? controller.isEdit = true : controller.isEdit = false;
    no != null ? controller.no = no : controller.no = '';

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<QuotesController>();
          debugPrint("Route popped with result: $result");
        } else {
          debugPrint("Pop prevented!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () =>
              controller.focusNodes.forEach((_, node) => node.unfocus()),
          child: SingleChildScrollView(
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
                        value: controller.selectedCustomer.value.isEmpty == true
                            ? null
                            : controller.selectedCustomer.value,
                        onChanged: (value) {
                          controller.selectedCustomer.value = value!;
                          controller.getSelectedContactDetails(value);
                        },
                        expandInRow: true,
                      ),
                    ),
                    //TODO: Go to add customer page
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.add),
                      ),
                    ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buttonWidget(
                      title: "Next",
                      onTap: () {
                        DefaultTabController.of(context).animateTo(1);
                        showlog("Next :: Add inquirt customer");
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
    );
  }
}

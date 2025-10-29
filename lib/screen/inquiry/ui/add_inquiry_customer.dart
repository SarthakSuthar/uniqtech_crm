import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/inquiry/controller/inquiry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddInquiryCustomer extends StatefulWidget {
  const AddInquiryCustomer({super.key, required this.no, required this.isEdit});

  final String? no;
  final bool isEdit;

  @override
  State<AddInquiryCustomer> createState() => _AddInquiryCustomerState();
}

class _AddInquiryCustomerState extends State<AddInquiryCustomer> {
  final InquiryController controller = Get.put(InquiryController());

  final _formKey = GlobalKey<FormState>();

  // late InquiryController controller;

  // final InquiryController controller = Get.find<InquiryController>();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      // controller.setEditDetails();

      controller.getInquiryById(widget.no!).then((value) async {
        controller.controllers['num']!.text = value.id.toString();
        controller.controllers['date']!.text = value.date.toString();
        controller.controllers['social']!.text = value.source.toString();

        await controller.setCustomerDetails(widget.no!);
        controller.controllers['name1']!.text = controller.customerName.value;
        controller.controllers['email']!.text = controller.custEmail.value;
        controller.controllers['mobile']!.text = controller.custMobile.value;
        controller.selectedCustomer.value = controller.customerName.value;

        await controller.getinquiryProductList();
      });
    }

    //Create controller here (safe to use widget values)
    // controller = Get.put(
    //   InquiryController(isEdit: widget.isEdit, no: widget.no),
    //   tag: widget.no ?? 'new', // unique tag per inquiry
    // );
  }

  @override
  Widget build(BuildContext context) {
    widget.isEdit == true
        ? controller.isEdit = true
        : controller.isEdit = false;
    widget.no != null ? controller.no = widget.no : controller.no = '';

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<InquiryController>();
          AppUtils.showlog("Route popped with result: $result");
        } else {
          AppUtils.showlog("Pop prevented!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: FocusScope(
            node: FocusScopeNode(),
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
                                controller.selectedCustomer.value.isEmpty ==
                                    true
                                ? null
                                : controller.selectedCustomer.value,
                            onChanged: (value) async {
                              controller.selectedCustomer.value = value!;
                              await controller.getSelectedContactDetails(value);
                            },
                            expandInRow: true,
                          ),
                        ),
                        // Go to add customer page
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
      ),
    );
  }
}

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/inquiry/controller/inquiry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiryFollowup extends StatefulWidget {
  final String inquiryId;
  const InquiryFollowup({super.key, required this.inquiryId});

  @override
  State<InquiryFollowup> createState() => _InquiryFollowupState();
}

class _InquiryFollowupState extends State<InquiryFollowup> {
  final InquiryController controller = Get.put(InquiryController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.getInquiryFollowupList(int.parse(widget.inquiryId));
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        appBar: appBar(title: "Inquiry Followup"),
        drawer: AppDrawer(),
        body: GestureDetector(
          onTap: () {
            controller.focusNodes['followupDate']!.unfocus();
            controller.focusNodes['followupStatus']!.unfocus();
            controller.focusNodes['followupAssignedTo']!.unfocus();
            controller.focusNodes['followupRemarks']!.unfocus();
            controller.followupSelected.value = false;
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Followup",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        datePickerWidget(
                          icon: Icons.calendar_month,
                          controller: controller.controllers["followupDate"]!,
                          context: context,
                          expandInRow: true,
                        ),
                        Obx(() {
                          return dropdownWidget(
                            hintText: "Select Followup",
                            icon: Icons.folder_outlined,
                            items: ["1", "2", "3"],
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectedFollowupType.value = val;
                              }
                              AppUtils.showlog(
                                "selected value : ${controller.selectedFollowupType.value}",
                              );
                            },
                            value:
                                controller.selectedFollowupType.isEmpty == true
                                ? null
                                : controller.selectedFollowupType.value,
                            expandInRow: true,
                          );
                        }),
                      ],
                    ),
                    Obx(() {
                      return Row(
                        children: [
                          dropdownWidget(
                            hintText: "Select Status",
                            icon: Icons.bar_chart_outlined,
                            items: ["1", "2", "3"],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedFollowupStatus.value = value;
                              }
                              AppUtils.showlog(
                                "selected value : ${controller.selectedFollowupStatus.value}",
                              );
                            },
                            value:
                                controller.selectedFollowupStatus.isEmpty ==
                                    true
                                ? null
                                : controller.selectedFollowupStatus.value,
                            expandInRow: true,
                          ),
                          dropdownWidget(
                            hintText: "Select Assigned to",
                            icon: Icons.bar_chart_outlined,
                            items: ["1", "2", "3"],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedFollowupAssignedTo.value =
                                    value;
                              }
                              AppUtils.showlog(
                                "selected value : ${controller.selectedFollowupAssignedTo.value}",
                              );
                            },
                            value:
                                controller.selectedFollowupAssignedTo.isEmpty ==
                                    true
                                ? null
                                : controller.selectedFollowupAssignedTo.value,
                            expandInRow: true,
                          ),
                        ],
                      );
                    }),
                    inputWidget(
                      hintText: "Remark",
                      icon: Icons.note,
                      controller: controller.controllers["followupRemarks"]!,
                      context: context,
                      focusNode: controller.focusNodes["remarks"]!,
                      minLines: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buttonWidget(
                          title: "ADD",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await controller.addInquiryFollowup(
                                widget.inquiryId,
                              );
                            }
                            AppUtils.showlog("ADD: Inquoiry follow up");
                          },
                          context: context,
                        ),
                        Obx(() {
                          return controller.followupSelected.value == true
                              ? buttonWidget(
                                  title: "SAVE",
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await controller.updateInquiryFollowup(
                                        widget.inquiryId,
                                      );
                                    }
                                    AppUtils.showlog("SAVE: Inquiry follow up");
                                  },
                                  context: context,
                                )
                              : const SizedBox(); // show nothing when false
                        }),
                      ],
                    ),
                    Obx(
                      () => controller.inquiryFollowupList.isEmpty
                          ? Text("No data found")
                          : ListView.builder(
                              itemCount: controller.inquiryFollowupList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item =
                                    controller.inquiryFollowupList[index];
                                return followupItem(
                                  followupDate: item.followupDate,
                                  followupType: item.followupType!,
                                  followupAssignedTo: item.followupAssignedTo!,
                                  followupRemarks: item.followupRemarks!,
                                  followupStatus: item.followupStatus!,
                                );
                              },
                            ),
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

  Widget followupItem({
    required String followupDate,
    required String followupType,
    required String followupAssignedTo,
    required String followupRemarks,
    required String followupStatus,
  }) {
    return InkWell(
      onTap: () {
        controller.selectedFollowupDate.value = followupDate;
        controller.controllers['followupDate']!.text = followupDate;
        controller.selectedFollowupType.value = followupType;
        controller.selectedFollowupAssignedTo.value = followupAssignedTo;
        controller.controllers['followupRemarks']!.text = followupRemarks;
        controller.selectedFollowupStatus.value = followupStatus;
        controller.followupSelected.value = true;
        AppUtils.showlog("inquiry card tapped");
        AppUtils.showlog("-----updated details--------");
        AppUtils.showlog(
          "followup date : ${controller.selectedFollowupDate.value}",
        );
        AppUtils.showlog(
          "followup type : ${controller.selectedFollowupType.value}",
        );
        AppUtils.showlog(
          "followup assigned to : ${controller.selectedFollowupAssignedTo.value}",
        );
        AppUtils.showlog(
          "followup remarks : ${controller.controllers['followupRemarks']!.text}",
        );
        AppUtils.showlog(
          "followup status : ${controller.selectedFollowupStatus.value}",
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Followup Date"),
                  Text("Type"),
                  Text("Assigned to"),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(followupDate),
                  Text(followupStatus),
                  Text(followupAssignedTo),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

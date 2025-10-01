import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotesFollowup extends StatefulWidget {
  final String quotationId;
  const QuotesFollowup({super.key, required this.quotationId});

  @override
  State<QuotesFollowup> createState() => _QuotesFollowupState();
}

class _QuotesFollowupState extends State<QuotesFollowup> {
  final QuotesController controller = Get.put(QuotesController());

  @override
  initState() {
    super.initState();
    controller.getQuotationFollowupList(int.parse(widget.quotationId));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<QuotesController>();
          showlog("Route popped with result: $result");
        } else {
          showlog("Pop prevented!");
        }
      },
      child: Scaffold(
        appBar: appBar(title: "Quotes"),
        drawer: const AppDrawer(),
        body: GestureDetector(
          onTap: () {
            controller.focusNodes['followupDate']!.unfocus();
            controller.focusNodes['followupStatus']!.unfocus();
            controller.focusNodes['followupAssignedTo']!.unfocus();
            controller.focusNodes['followupRemarks']!.unfocus();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                      dropdownWidget(
                        hintText: "Select Followup",
                        icon: Icons.folder_outlined,
                        items: ["1", "2", "3"],
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectedFollowupType.value = val;
                          }
                          showlog(
                            "selected value : ${controller.selectedFollowupType.value}",
                          );
                        },
                        value: controller.selectedFollowupType.isEmpty == true
                            ? null
                            : controller.selectedFollowupType.value,
                        expandInRow: true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      dropdownWidget(
                        hintText: "Select Status",
                        icon: Icons.bar_chart_outlined,
                        items: ["1", "2", "3"],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedFollowupStatus.value = value;
                          }
                          showlog(
                            "selected value : ${controller.selectedFollowupStatus.value}",
                          );
                        },
                        value: controller.selectedFollowupStatus.isEmpty == true
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
                            controller.selectedFollowupAssignedTo.value = value;
                          }
                          showlog(
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
                  ),
                  inputWidget(
                    hintText: "Remark",
                    icon: Icons.note,
                    controller: controller.controllers["followupRemarks"]!,
                    context: context,
                    focusNode: controller.focusNodes["followupRemarks"]!,
                    minLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonWidget(
                        title: "ADD",
                        onTap: () async {
                          await controller.addQuotationFollowup(
                            widget.quotationId,
                          );
                          showlog("ADD: Inquoiry follow up");
                        },
                        context: context,
                      ),
                      buttonWidget(
                        title: "SAVE",
                        onTap: () async {
                          await controller.updateQuotationFollowup(
                            widget.quotationId,
                          );
                          showlog("SAVE: Inquoiry follow up");
                        },
                        context: context,
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.quotationFollowupList.isEmpty
                        ? Text("No data found")
                        : ListView.builder(
                            itemCount: controller.quotationFollowupList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => followupItem(
                              followupDate: controller
                                  .quotationFollowupList[index]
                                  .followupDate!,
                              followupType: controller
                                  .quotationFollowupList[index]
                                  .followupStatus!,
                              followupAssignedTo: controller
                                  .quotationFollowupList[index]
                                  .followupAssignedTo!,
                              followupRemarks: controller
                                  .quotationFollowupList[index]
                                  .followupRemarks!,
                              followupStatus: controller
                                  .quotationFollowupList[index]
                                  .followupStatus!,
                              followupId:
                                  controller.quotationFollowupList[index].id!,
                            ),
                          ),
                  ),
                ],
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
    required int followupId,
  }) {
    return InkWell(
      onTap: () async {
        controller.selectedFollowupDate.value = followupDate;
        controller.selectedFollowupType.value = followupType;
        controller.selectedFollowupAssignedTo.value = followupAssignedTo;
        controller.controllers['followupRemarks']!.text = followupRemarks;
        controller.selectedFollowupStatus.value = followupStatus;
        showlog("inquiry card tapped");

        await controller.setSelectedFollowupDetail(followupId);
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

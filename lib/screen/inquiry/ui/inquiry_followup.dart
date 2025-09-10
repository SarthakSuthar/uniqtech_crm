import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/inquiry/controller/inquiry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiryFollowup extends StatelessWidget {
  InquiryFollowup({super.key});

  final InquiryController controller = Get.put(InquiryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Inquiry"),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Followup", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              Row(
                children: [
                  datePickerWidget(
                    icon: Icons.calendar_month,
                    controller: controller
                        .controllers["date"]!, //TODO: add new foeld for this in controller
                    context: context,
                    expandInRow: true,
                  ),
                  dropdownWidget(
                    hintText: "Select Followup",
                    icon: Icons.folder_outlined,
                    items: ["1", "2", "3"],
                    onChanged: (value) => showlog("selected value : $value"),
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
                    onChanged: (value) => showlog("selected value : $value"),
                    expandInRow: true,
                  ),
                  dropdownWidget(
                    hintText: "Select Assigned to",
                    icon: Icons.bar_chart_outlined,
                    items: ["1", "2", "3"],
                    onChanged: (value) => showlog("selected value : $value"),
                    expandInRow: true,
                  ),
                ],
              ),
              inputWidget(
                hintText: "Remark",
                icon: Icons.note,
                controller: controller
                    .controllers["remarks"]!, // TODO: add avalue for this field in controller
                context: context,
                focusNode: controller.focusNodes["remarks"]!,
                minLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buttonWidget(
                    title: "ADD",
                    onTap: () {
                      showlog("ADD: Inquoiry follow up");
                    },
                    context: context,
                  ),
                  buttonWidget(
                    title: "SAVE",
                    onTap: () {
                      showlog("SAVE: Inquoiry follow up");
                    },
                    context: context,
                  ),
                ],
              ),
              ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => followupItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget followupItem() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Next Followup Date"),
                Text("Type"),
                Text("Assigned to"),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("12/12/2023"), Text("Call"), Text("Assigned 3")],
            ),
          ],
        ),
      ),
    );
  }
}

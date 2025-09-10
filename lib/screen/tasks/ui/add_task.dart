import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/tasks/controller/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTask extends StatelessWidget {
  final bool isEdit;

  AddTask({super.key, required this.isEdit});

  final TasksController controller = Get.put(TasksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Tasks"),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                inputWidget(
                  hintText: "No",
                  icon: Icons.numbers,
                  controller: controller.controllers["no"]!,
                  context: context,
                  focusNode: controller.focusNodes["no"]!,
                  expandInRow: true,
                ),
                datePickerWidget(
                  icon: Icons.calendar_month,
                  controller: controller.controllers["date"]!,
                  context: context,
                  expandInRow: true,
                ),
              ],
            ),
            inputWidget(
              hintText: "Task Discription",
              icon: Icons.work,
              controller: controller.controllers["taskDiscription"]!,
              context: context,
              focusNode: controller.focusNodes["taskDiscription"]!,
              minLines: 2,
            ),
            inputWidget(
              hintText: "Attached",
              icon: Icons.person,
              controller: controller.controllers["attached"]!,
              context: context,
              focusNode: controller.focusNodes["attached"]!,
            ),

            // Image view
            Row(
              children: [
                inputWidget(
                  hintText: "Work",
                  icon: Icons.chat_rounded,
                  controller: controller.controllers["work"]!,
                  context: context,
                  focusNode: controller.focusNodes["work"]!,
                  expandInRow: true,
                ),
                inputWidget(
                  hintText: "Work Type",
                  icon: Icons.task,
                  controller: controller.controllers["workType"]!,
                  context: context,
                  focusNode: controller.focusNodes["workType"]!,
                  expandInRow: true,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buttonWidget(
                  title: isEdit ? "UPDATE" : "ADD TASK",
                  onTap: () {
                    showlog("Tasks : Add task button");
                  },
                  context: context,
                ),
                buttonWidget(
                  title: "RESET",
                  onTap: () {
                    showlog("Tasks : Add task button");
                  },
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/tasks/controller/tasks_controller.dart';
import 'package:crm/screen/tasks/repo/tasks_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTask extends StatefulWidget {
  final String? no;
  final bool isEdit;

  const AddTask({super.key, required this.isEdit, this.no});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TasksController controller = Get.put(TasksController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isEdit) {
        await controller.setEditDetails(widget.no ?? '0');
      } else {
        controller.controllers["no"]!.text = (await TasksRepo().getNextTaskId())
            .toString();
        if (widget.no != null) {
          controller.controllers["no"]!.text = widget.no!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.isEdit
    //     ? controller.setEditDetails()
    //     : controller.controllers["no"]!.text = (controller.taskList.length + 1)
    //           .toString();
    // widget.no != null ? controller.controllers["no"]!.text = widget.no! : null;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<TasksController>();
          debugPrint("Route popped with result: $result");
        } else {
          debugPrint("Pop prevented!");
        }
      },
      child: GestureDetector(
        onTap: () => controller.focusNodes.forEach((_, node) => node.unfocus()),
        child: Scaffold(
          appBar: appBar(title: "Tasks"),
          drawer: AppDrawer(),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                          readOnly: true,
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

                    Row(
                      children: [
                        dropdownWidget(
                          hintText: "Work Type",
                          icon: Icons.work,
                          items: controller.typeOfWorkList,
                          // onChanged: controller.updateTypeOfWork,
                          onChanged: (value) {
                            controller.selectedTypeOfWork.value = value!;
                            controller.controllers["workType"]!.text = value;
                          },
                          // value: controller.selectedTypeOfWork.value,
                          value:
                              controller.selectedTypeOfWork.value.isEmpty ==
                                  true
                              ? null
                              : controller.selectedTypeOfWork.value,
                          expandInRow: true,
                        ),

                        inputWidget(
                          hintText: "Assigned to",
                          icon: Icons.task,
                          controller: controller.controllers["assignedTo"]!,
                          context: context,
                          focusNode: controller.focusNodes["assignedTo"]!,
                          expandInRow: true,
                          readOnly: true,
                        ),
                      ],
                    ),

                    Obx(() {
                      if (controller.attachedFiles.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => fileSelectWidget(context),
                              );
                              AppUtils.showlog("file select widget tapped");
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.folder),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Attached",
                                          ), // change to file name after selecting
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return controller.attachedFiles.first.split('.').last ==
                                    'png' ||
                                controller.attachedFiles.first
                                        .split('.')
                                        .last ==
                                    'jpg' ||
                                controller.attachedFiles.first
                                        .split('.')
                                        .last ==
                                    'jpeg'
                            ? Image.file(File(controller.attachedFiles.first))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(30.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              controller.attachedFiles.first
                                                          .split('.')
                                                          .last ==
                                                      'pdf'
                                                  ? Icons.picture_as_pdf
                                                  : Icons.file_copy,
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              controller.attachedFiles.first
                                                  .split('/')
                                                  .last
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      }
                    }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buttonWidget(
                          title: widget.isEdit ? "UPDATE" : "ADD TASK",
                          onTap: () {
                            // if (_formKey.currentState!.validate()) {
                            //   widget.isEdit
                            //       ? controller.updateTask()
                            //       : controller.addTask();
                            // }
                            widget.isEdit
                                ? controller.updateTask()
                                : controller.addTask();
                            AppUtils.showlog("Tasks : Add task button");
                          },
                          context: context,
                        ),
                        buttonWidget(
                          title: "RESET",
                          onTap: () {
                            controller.resetAllFields();
                            AppUtils.showlog("Tasks : Add task button");
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

  Widget fileSelectWidget(BuildContext context) {
    return AlertDialog(
      title: const Text("Add File"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              await controller.pickFile();
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.upload_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Upload from File",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              await controller.captureFromCamera();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    "Upload from Camera",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

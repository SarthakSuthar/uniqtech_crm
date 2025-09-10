import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/tasks/controller/tasks_controller.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final TasksController controller = Get.put(TasksController());

  // FocuseNodes
  FocusNode noFocus = FocusNode();
  FocusNode searchFocus = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    noFocus.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Tasks"),
      drawer: const AppDrawer(),
      body: GestureDetector(
        onTap: () {
          noFocus.unfocus();
          searchFocus.unfocus();
        },
        child: Column(
          children: [
            Row(
              children: [
                inputWidget(
                  focusNode: controller.focusNodes["noSearch"]!,
                  controller: controller.controllers["noSearch"]!,
                  hintText: "No..",
                  icon: Icons.numbers,
                  context: context,
                  expandInRow: true,
                ),
                dropdownWidget(
                  hintText: "Type of Work",
                  icon: Icons.work,
                  items: controller.typeOfWorkList.toString().split(","),
                  onChanged: (value) => controller.updateTypeOfWork,
                  expandInRow: true,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buttonWidget(
                    title: "Clear",
                    context: context,
                    onTap: () {
                      controller.controllers["noSearch"]!.clear();
                      showlog("Clear button pressed");
                    },
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    title: "Search",
                    context: context,
                    onTap: () {
                      // controller.noController.clear();
                      showlog("Clear button pressed");
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => tasksListWidget(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showlog("Action button pressed");
          Get.toNamed(AppRoutes.addTask, arguments: false);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tasksListWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("No."),
                      Text("Date"),
                      Text("Assigned to"),
                      const SizedBox(height: 40),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1"),
                      Text("12/12/2025"),
                      Text("Assign 3"),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      showlog("edit button taped");
                      Get.toNamed(AppRoutes.addTask, arguments: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  InkWell(
                    onTap: () {
                      showlog("delete button taped");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delete,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

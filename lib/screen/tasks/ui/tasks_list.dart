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

  final TextEditingController noController = TextEditingController();
  final TextEditingController workTypeController = TextEditingController();

  // FocuseNodes
  FocusNode noFocus = FocusNode();
  FocusNode workTypeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.getTaskList();
    controller.getFilesList();
  }

  @override
  void dispose() {
    controller.dispose();
    noController.dispose();
    workTypeController.dispose();
    noFocus.dispose();
    workTypeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Tasks"),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () {
          noFocus.unfocus();
          workTypeFocus.unfocus();
        },
        child: Column(
          children: [
            Row(
              children: [
                inputWidget(
                  focusNode: noFocus,
                  controller: noController,
                  hintText: "No..",
                  icon: Icons.numbers,
                  context: context,
                  expandInRow: true,
                ),
                dropdownWidget(
                  hintText: "Type of Work",
                  icon: Icons.work,
                  items: controller.typeOfWorkList,
                  onChanged: controller.updateTypeOfWork,
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
                      AppUtils.showlog("Clear button pressed");
                    },
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    title: "Search",
                    context: context,
                    onTap: () {
                      // controller.noController.clear();
                      if (noController.text.isNotEmpty) {
                        controller.searchResult(noController.text);
                      }
                      //  else if (searchController.text.isNotEmpty) {
                      //   controller.searchResult(searchController.text);
                      // }
                      AppUtils.showlog("Search button pressed");
                    },
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.filteredList.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset("assets/images/no_data.png", scale: 2),
                        Text(
                          "No Data Found",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.filteredList.length,
                        itemBuilder: (context, index) => tasksListWidget(
                          no: controller.filteredList[index].id.toString(),
                          date: controller.filteredList[index].date.toString(),
                          assignedTo: controller.filteredList[index].assignedTo
                              .toString(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          AppUtils.showlog("Action button pressed");
          Get.toNamed(AppRoutes.addTask, arguments: {'isEdit': false});
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tasksListWidget({
    required String no,
    required String date,
    required String assignedTo,
  }) {
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
                      Text(no),
                      Text(date),
                      Text(assignedTo),
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
                      AppUtils.showlog("no from tasks list : $no");
                      Get.toNamed(
                        AppRoutes.addTask,
                        arguments: {'no': no, 'isEdit': true},
                      );
                      AppUtils.showlog("edit button taped");
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
                    onTap: () async {
                      await controller.deleteTask(int.parse(no));
                      AppUtils.showlog("delete button taped");
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

import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_const/widgets/app_bar.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  TextEditingController noController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // FocuseNodes
  FocusNode noFocus = FocusNode();
  FocusNode searchFocus = FocusNode();

  @override
  void dispose() {
    noController.dispose();
    searchController.dispose();
    noFocus.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Order"),
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
                  focusNode: noFocus,
                  controller: noController,
                  hintText: "No..",
                  icon: Icons.numbers,
                  context: context,
                  expandInRow: true,
                ),
                inputWidget(
                  focusNode: searchFocus,
                  controller: searchController,
                  hintText: "Customer name",
                  icon: Icons.person,
                  context: context,
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
                      noController.clear();
                      searchController.clear();
                      showlog("Clear button pressed");
                    },
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    title: "Search",
                    context: context,
                    onTap: () {
                      noController.clear();
                      searchController.clear();
                      showlog("Clear button pressed");
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => orderListWidget(),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showlog("Action button pressed");
          Get.toNamed(AppRoutes.addOrder);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget orderListWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("No."),
                      Text("Customer Name"),
                      Text("Email"),
                      Text("Mobile No."),
                      const SizedBox(height: 40),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1"),
                      Text("Heet"),
                      Text("someone@example.com"),
                      Text("+91 1234567890"),
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
                      showlog("print button taped");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.print,
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

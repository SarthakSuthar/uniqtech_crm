import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/orders/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_const/widgets/app_bar.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final OrderController controller = Get.put(OrderController());

  TextEditingController noController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // FocuseNodes
  FocusNode noFocus = FocusNode();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    controller.getOrderList();
    super.initState();
  }

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
      drawer: AppDrawer(),
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
                      AppUtils.showlog("Clear button pressed");
                    },
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    title: "Search",
                    context: context,
                    onTap: () {
                      if (noController.text.isNotEmpty) {
                        controller.searchResult(noController.text);
                      } else if (searchController.text.isNotEmpty) {
                        controller.searchResult(searchController.text);
                      }
                      AppUtils.showlog("search button pressed");
                    },
                  ),
                ),
              ],
            ),

            Obx(
              () => controller.filterendList.isEmpty
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
                        itemCount: controller.filterendList.length,
                        itemBuilder: (context, index) {
                          final id = controller.filterendList[index].id!;

                          return FutureBuilder(
                            future: getUserDetails(id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text("No contact details");
                              } else {
                                final details = snapshot.data!;
                                final name = details[0];
                                final email = details[1];
                                final mobile = details[2];

                                return orderListWidget(
                                  no: id.toString(),
                                  customerName: name,
                                  email: email,
                                  mobileNo: mobile,
                                  onEdit: () {
                                    Get.toNamed(
                                      AppRoutes.addOrder,
                                      arguments: {
                                        'no': id.toString(),
                                        'isEdit': true,
                                      },
                                    );
                                    AppUtils.showlog("edit button tapped");
                                  },
                                  onDelete: () {
                                    controller.deleteOrder(id: id);
                                    AppUtils.showlog("delete button tapped");
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppUtils.showlog("Action button pressed");
          Get.toNamed(AppRoutes.addOrder, arguments: {'isEdit': false});
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  Future<List<String>> getUserDetails(int id) async {
    try {
      final result = await ContactsRepo.getContactById(id.toString());
      return [
        result.custName.toString(),
        result.email.toString(),
        result.mobileNo.toString(),
      ];
    } catch (e) {
      AppUtils.showlog(e.toString());
      return [];
    }
  }

  Widget orderListWidget({
    required String no,
    required String customerName,
    required String email,
    required String mobileNo,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
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
                      Text(no),
                      Text(customerName),
                      Text(email),
                      Text(mobileNo),
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
                    onTap: onEdit,
                    // onTap: () {
                    //   Get.toNamed(
                    //     AppRoutes.addOrder,
                    //     arguments: {'no': no, 'isEdit': true},
                    //   );
                    //   AppUtils.showlog("edit button taped");
                    // },
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
                      Get.toNamed(
                        AppRoutes.orderInvoice,
                        arguments: {'orderId': no},
                      );
                      AppUtils.showlog("print button taped");
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
                    onTap: onDelete,
                    // onTap: () async {
                    //   await controller.deleteOrder(id: int.parse(no));
                    //   AppUtils.showlog("delete button taped");
                    // },
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

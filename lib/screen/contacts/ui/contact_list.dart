import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/contacts/controller/customer_controller.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final AddCustomerController controller = Get.put(AddCustomerController());

  // TextEditingController
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
      appBar: appBar(title: "Contact"),
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
                      // controller.searchNumResult(noController.text);
                      // controller.searchCustomerResult(searchController.text);
                      controller.searchResult(noController.text);
                      controller.searchResult(searchController.text);
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
                        itemCount: controller.filterendList.length,
                        itemBuilder: (context, index) => contactListWidget(
                          no: controller.filterendList[index].id.toString(),
                          customerName:
                              controller.filterendList[index].custName ?? '',
                          email: controller.filterendList[index].email ?? '',
                          mobileNo:
                              controller.filterendList[index].mobileNo ?? '',
                          context: context,
                          onEdit: () {
                            Get.toNamed(
                              AppRoutes.addContact,
                              arguments: {
                                'isEdit': true,
                                'uid': controller.filterendList[index].id
                                    .toString(),
                              },
                            );
                          },
                          onDelete: () {
                            controller.deleteContact(
                              controller.filterendList[index].id.toString(),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppUtils.showlog("Action button pressed");
          Get.toNamed(AppRoutes.addContact);
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

  // Widget contactListWidget({
  //   required String no,
  //   required String customerName,
  //   required String email,
  //   required String mobileNo,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //       child: Stack(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text("No."),
  //                     Text("Customer Name"),
  //                     Text("Email"),
  //                     Text("Mobile No."),
  //                     const SizedBox(height: 20),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(no),
  //                     Text(customerName),
  //                     Text(email),
  //                     Text(mobileNo),
  //                     const SizedBox(height: 20),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Positioned(
  //             right: 5,
  //             bottom: 5,
  //             child: Row(
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     AppUtils.showlog("edit button taped");
  //                     //pass uid
  //                     //get data for that uid
  //                     //maintain status for update or new
  //                     Get.toNamed(
  //                       AppRoutes.addContact,
  //                       arguments: {'isEdit': true, 'uid': no},
  //                     );
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).primaryColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Icon(
  //                         Icons.edit,
  //                         color:
  //                             Theme.of(context).brightness == Brightness.light
  //                             ? Colors.white
  //                             : Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 InkWell(
  //                   onTap: () {
  //                     controller.deleteContact(no);
  //                     AppUtils.showlog("delete");
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: Theme.of(context).primaryColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Icon(
  //                         Icons.delete,
  //                         color:
  //                             Theme.of(context).brightness == Brightness.light
  //                             ? Colors.white
  //                             : Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget contactListWidget({
    required BuildContext context,
    required String no,
    required String customerName,
    required String email,
    required String mobileNo,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading avatar or index
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Text(
                    no,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Info section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              email,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            mobileNo,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      context,
                      icon: Icons.edit_rounded,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 8),
                    _iconButton(
                      context,
                      icon: Icons.delete_rounded,
                      onTap: onDelete,
                      isDanger: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDanger
              ? Colors.redAccent.withOpacity(0.1)
              : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDanger ? Colors.redAccent : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

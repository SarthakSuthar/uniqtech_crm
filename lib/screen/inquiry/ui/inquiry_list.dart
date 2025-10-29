import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_toast.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/contacts/repo/contact_repo.dart';
import 'package:crm/screen/inquiry/controller/inquiry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiryList extends StatefulWidget {
  const InquiryList({super.key});

  @override
  State<InquiryList> createState() => _InquiryListState();
}

class _InquiryListState extends State<InquiryList> {
  final InquiryController controller = Get.put(InquiryController());
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(title: "Inquiry"),
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
                  : width >= 800
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            // childAspectRatio: 3.5, // Adjust as needed
                            childAspectRatio: 5, // Adjust as needed
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: controller.filterendList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final contactId = controller.filterendList[index].id!;
                        return FutureBuilder<List<String>>(
                          future: getUserDetails(
                            contactId,
                          ), // 👈 async call handled properly
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

                              return contactListWidget(
                                no: contactId.toString(),
                                email: email,
                                mobileNo: mobile,
                                customerName: name,
                                onEdit: () {
                                  Get.toNamed(
                                    AppRoutes.addInquiry,
                                    arguments: {
                                      'no': contactId.toString(),
                                      'isEdit': true,
                                    },
                                  );
                                  AppUtils.showlog("edit button tapped");
                                },
                                onDelete: () {
                                  controller.deleteInquiry(id: contactId);
                                  AppUtils.showlog("delete button tapped");
                                },
                                context: context,
                              );
                            }
                          },
                        );
                      },
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.filterendList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final contactId = controller.filterendList[index].id!;

                          return FutureBuilder<List<String>>(
                            future: getUserDetails(
                              contactId,
                            ), // 👈 async call handled properly
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

                                return contactListWidget(
                                  no: contactId.toString(),
                                  email: email,
                                  mobileNo: mobile,
                                  customerName: name,
                                  onEdit: () {
                                    Get.toNamed(
                                      AppRoutes.addInquiry,
                                      arguments: {
                                        'no': contactId.toString(),
                                        'isEdit': true,
                                      },
                                    );
                                    AppUtils.showlog("edit button tapped");
                                  },
                                  onDelete: () {
                                    controller.deleteInquiry(id: contactId);
                                    AppUtils.showlog("delete button tapped");
                                  },
                                  context: context,
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
          Get.toNamed(AppRoutes.addInquiry, arguments: {'isEdit': false});
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

  ///return order
  ///1. name
  ///2. email
  ///3. mobile
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
          color: Theme.of(context).cardColor.withAlpha((255 * 0.9).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withAlpha((255 * 0.15).round()),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          splashColor: Theme.of(
            context,
          ).primaryColor.withAlpha((255 * 0.1).round()),
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
                  ).primaryColor.withAlpha((255 * 0.1).round()),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconButton(
                        context,
                        icon: Icons.edit_rounded,
                        onTap: onEdit,
                        lable: "Edit",
                      ),
                      const SizedBox(width: 8),
                      _iconButton(
                        context,
                        icon: Icons.logout_outlined,
                        lable: "quoote",
                        onTap: () async {
                          await controller.convertInquiryToQuotation(
                            inquiryId: no,
                          );
                          AppUtils.showlog("convert to quote button taped");
                        },
                      ),
                      const SizedBox(width: 8),
                      _iconButton(
                        context,
                        icon: Icons.edit_document,
                        lable: "Follow-up",
                        onTap: () {
                          AppUtils.showlog("Follow up : inquiry");
                          AppUtils.showlog(
                            "Inquiry id parsing from list : $no",
                          );
                          Get.toNamed(
                            AppRoutes.inquiryFollowup,
                            arguments: {'inquiryId': no},
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _iconButton(
                        context,
                        icon: Icons.delete_rounded,
                        onTap: onDelete,
                        isDanger: true,
                        lable: "Delete",
                      ),
                    ],
                  ),
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
    required String lable,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      onLongPress: () => appToast(lable),
      borderRadius: BorderRadius.circular(12),
      splashColor: Theme.of(
        context,
      ).primaryColor.withAlpha((255 * 0.1).round()),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDanger
              ? Colors.redAccent.withAlpha((255 * 0.1).round())
              : Theme.of(context).primaryColor.withAlpha((255 * 0.1).round()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDanger
                  ? Colors.redAccent
                  : Theme.of(context).primaryColor,
            ),
            if (width > 800) const SizedBox(width: 8),
            if (width > 800) Text(lable),
          ],
        ),
      ),
    );
  }
}

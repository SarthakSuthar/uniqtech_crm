import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:crm/services/firestore_sync.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    syncToCloud(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Dashboard"),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/logo.png'),
              ),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true, // Add this to prevent unbounded height
                physics:
                    NeverScrollableScrollPhysics(), // Add this to prevent scrolling

                children: [
                  dashboardWidget(
                    icon: Icons.contact_mail,
                    title: "Contact",
                    context: context,
                    onTap: () {
                      AppUtils.showlog("Contact pressed");
                      Get.toNamed(AppRoutes.contactList);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.inbox,
                    title: "Inquiry",
                    context: context,
                    onTap: () {
                      AppUtils.showlog("Inquiry pressed");
                      Get.toNamed(AppRoutes.inquiry);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.contact_mail,
                    title: "Quotation",
                    context: context,
                    onTap: () {
                      AppUtils.showlog("Quotation pressed");
                      Get.toNamed(AppRoutes.quote);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.inbox,
                    title: "Order",
                    context: context,
                    onTap: () {
                      AppUtils.showlog("Order pressed");
                      Get.toNamed(AppRoutes.order);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.contact_mail,
                    title: "Task",
                    context: context,
                    onTap: () {
                      AppUtils.showlog("Task pressed");
                      Get.toNamed(AppRoutes.tasks);
                    },
                  ),
                  // dashboardWidget(
                  //   icon: Icons.inbox,
                  //   title: "Report",
                  //   context: context,
                  //   onTap: () {
                  //     AppUtils.showlog("Report pressed");
                  //     Get.toNamed(AppRoutes.report);
                  //   },
                  // ),
                  dashboardWidget(
                    icon: Icons.sync_alt,
                    title: "Sync",
                    onTap: () {
                      syncToCloud(context: context);
                      AppUtils.showlog("Sync pressed");
                    },
                    context: context,
                  ),
                ],
              ),

              // dashboardWidget(
              //   icon: Icons.sync_alt,
              //   title: "Sync",
              //   onTap: () {
              //     AppUtils.showlog("Sync pressed");
              //   },
              //   context: context,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget dashboardWidget({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  //   required BuildContext context,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Card(
  //       child: Column(
  //         mainAxisAlignment:
  //             MainAxisAlignment.center, // Center content vertically
  //         children: [
  //           Icon(icon, size: 40, color: Theme.of(context).primaryColor),
  //           Text(title),
  //         ], // Increase icon size for better visibility
  //       ),
  //     ),
  //   );
  // }

  Widget dashboardWidget({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size:
                                constraints.maxHeight * 0.25, // responsive icon
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        flex: 1,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                          overflow:
                              TextOverflow.ellipsis, // ✅ Prevents overflow
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

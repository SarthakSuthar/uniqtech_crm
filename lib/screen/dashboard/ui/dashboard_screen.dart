import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Dashboard"),
      drawer: const AppDrawer(),
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
                      showlog("Contact pressed");
                      Get.toNamed(AppRoutes.contactList);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.inbox,
                    title: "Inquiry",
                    context: context,
                    onTap: () {
                      showlog("Inquiry pressed");
                      Get.toNamed(AppRoutes.inquiry);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.contact_mail,
                    title: "Quotation",
                    context: context,
                    onTap: () {
                      showlog("Quotation pressed");
                      Get.toNamed(AppRoutes.quote);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.inbox,
                    title: "Order",
                    context: context,
                    onTap: () {
                      showlog("Order pressed");
                      Get.toNamed(AppRoutes.order);
                    },
                  ),
                  dashboardWidget(
                    icon: Icons.contact_mail,
                    title: "Task",
                    context: context,
                    onTap: () {
                      showlog("Task pressed");
                      Get.toNamed(AppRoutes.tasks);
                    },
                  ),
                  // dashboardWidget(
                  //   icon: Icons.inbox,
                  //   title: "Report",
                  //   context: context,
                  //   onTap: () {
                  //     showlog("Report pressed");
                  //     Get.toNamed(AppRoutes.report);
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardWidget({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            Text(title),
          ], // Increase icon size for better visibility
        ),
      ),
    );
  }
}

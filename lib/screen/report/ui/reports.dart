import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Reports"),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true, // Add this to prevent unbounded height
                physics:
                    NeverScrollableScrollPhysics(), // Add this to prevent scrolling

                children: [
                  reportsWidget(
                    icon: Icons.image_search,
                    title: "TARGET VS SALES",
                    context: context,
                    onTap: () {
                      showlog("Report pressed");
                    },
                  ),
                  reportsWidget(
                    icon: Icons.logout,
                    title: "TODAY FOLLOW-UP",
                    context: context,
                    onTap: () {
                      showlog("Report pressed");
                    },
                  ),
                  reportsWidget(
                    icon: Icons.inbox,
                    title: "INQUIRY PROGRESS REPORT",
                    context: context,
                    onTap: () {
                      showlog("Report pressed");
                    },
                  ),
                  reportsWidget(
                    icon: Icons.inbox,
                    title: "TODAY TASK",
                    context: context,
                    onTap: () {
                      showlog("Report pressed");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportsWidget({
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            Text(title),
          ], // Increase icon size for better visibility
        ),
      ),
    );
  }
}

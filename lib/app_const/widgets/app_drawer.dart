import 'package:crm/screen/masters/product/ui/add_product_screen.dart';
import 'package:crm/screen/masters/terms/ui/term_master.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //company logo
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 20),
                Text("Uniqtech Solutions"),
                Text("Mikir@uniqtechsolutions.com"),
              ],
            ),
          ),

          drawerItem(Icons.home, "Home", () {}),
          drawerItem(Icons.contact_page, "Contact", () {}),
          drawerItem(Icons.inbox, "Inquiry", () {}),
          drawerItem(Icons.inbox, "Quote", () {}),
          drawerItem(Icons.inbox, "Order", () {}),
          drawerItemWithNestedRoutes(Icons.settings, "Masters", [
            InkWell(
              onTap: () {
                Get.to(() => AddProductScreen());
              },
              child: drawerItem(Icons.inbox, "Product", () {}),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddProductScreen());
              },
              child: drawerItem(Icons.inbox, "UOM", () {}),
            ),
            InkWell(
              onTap: () {
                Get.to(() => TermMaster());
              },
              child: drawerItem(Icons.inbox, "Term's", () {}),
            ),
          ]),
          drawerItem(Icons.task, "Task", () {}),
          drawerItem(Icons.logout, "Logout", () {}),
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String name, VoidCallback? onTap) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 10),
            Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItemWithNestedRoutes(
    IconData icon,
    String name,
    List<Widget> children,
  ) {
    return ExpansionTile(
      leading: Icon(icon, size: 30),
      title: Text(
        name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      children: children,
    );
  }
}

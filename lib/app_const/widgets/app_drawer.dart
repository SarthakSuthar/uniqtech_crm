import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/contacts/ui/contact_list.dart';
import 'package:crm/screen/dashboard/ui/dashboard_screen.dart';
import 'package:crm/screen/inquiry/ui/inquiry_list.dart';
import 'package:crm/screen/masters/product/ui/add_product_screen.dart';
import 'package:crm/screen/masters/terms/ui/term_master.dart';
import 'package:crm/screen/masters/uom/ui/uom_screen.dart';
import 'package:crm/screen/orders/ui/order_list.dart';
import 'package:crm/screen/quotes/ui/quote_list.dart';
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

          drawerItem(Icons.home, "Home", () {
            Get.to(() => DashboardScreen());
          }),
          drawerItem(Icons.contact_page, "Contacts", () {
            Get.to(() => ContactList());
          }),
          drawerItem(Icons.inbox, "Inquiries", () {
            Get.to(() => InquiryList());
          }),
          drawerItem(Icons.inbox, "Quote", () {
            Get.to(() => QuoteList());
          }),
          drawerItem(Icons.inbox, "Order", () {
            Get.to(() => OrderList());
          }),

          // drawerItemWithNestedRoutes(Icons.settings, "Masters", [
          //   InkWell(
          //     onTap: () {
          //       Get.to(() => AddProductScreen());
          //     },
          //     child: drawerItem(Icons.inbox, "Product", () {}),
          //   ),
          //   InkWell(
          //     onTap: () {
          //       Get.to(() => AddUomScreen());
          //     },
          //     child: drawerItem(Icons.inbox, "UOM", () {}),
          //   ),
          //   InkWell(
          //     onTap: () {
          //       Get.to(() => const TermMaster());
          //     },
          //     child: drawerItem(Icons.inbox, "Term's", () {}),
          //   ),
          // ]),
          drawerItemWithNestedRoutes(Icons.settings, "Masters", [
            drawerItem(Icons.inbox, "Product", () {
              Get.to(() => AddProductScreen());
            }),
            drawerItem(Icons.inbox, "UOM", () {
              Get.to(() => AddUomScreen());
            }),
            drawerItem(Icons.inbox, "Term's", () {
              Get.to(() => const TermMaster());
            }),
          ]),

          drawerItem(Icons.task, "Task", () {
            Get.to(() => AppRoutes.tasks);
          }),
          drawerItem(Icons.logout, "Logout", () {
            //TODO: add logout alertBx logic

            Get.dialog(
              AlertDialog(
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(), // cancel
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // logout logic
                      Get.back();
                      Get.offAllNamed('/login');
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
              barrierDismissible: false, // force user to pick
            );
          }),
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String name, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
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

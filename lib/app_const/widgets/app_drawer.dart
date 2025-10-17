import 'package:crm/routes/app_routes.dart';
import 'package:crm/screen/contacts/ui/contact_list.dart';
import 'package:crm/screen/dashboard/ui/dashboard_screen.dart';
import 'package:crm/screen/inquiry/ui/inquiry_list.dart';
import 'package:crm/screen/login/controller/login_controller.dart';
import 'package:crm/screen/masters/product/ui/add_product_screen.dart';
import 'package:crm/screen/masters/terms/ui/term_master.dart';
import 'package:crm/screen/masters/uom/ui/uom_screen.dart';
import 'package:crm/screen/orders/ui/order_list.dart';
import 'package:crm/screen/quotes/ui/quote_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //company logo
            Container(
              // color: Theme.of(context).scaffoldBackgroundColor,
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

            drawerItem(
              icon: Icons.home,
              name: "Home",
              onTap: () {
                Get.to(() => DashboardScreen());
              },
              context: context,
            ),
            drawerItem(
              icon: Icons.contact_page,
              name: "Contacts",
              onTap: () {
                Get.to(() => ContactList());
              },
              context: context,
            ),
            drawerItem(
              icon: Icons.inbox,
              name: "Inquiries",
              onTap: () {
                Get.to(() => InquiryList());
              },
              context: context,
            ),
            drawerItem(
              icon: Icons.inbox,
              name: "Quote",
              onTap: () {
                Get.to(() => QuoteList());
              },
              context: context,
            ),
            drawerItem(
              icon: Icons.inbox,
              name: "Order",
              onTap: () {
                Get.to(() => OrderList());
              },
              context: context,
            ),

            drawerItemWithNestedRoutes(
              icon: Icons.settings,
              name: "Masters",
              children: [
                drawerItem(
                  icon: Icons.inbox,
                  name: "Product",
                  onTap: () {
                    Get.to(() => AddProductScreen());
                  },
                  context: context,
                ),
                drawerItem(
                  icon: Icons.inbox,
                  name: "UOM",
                  onTap: () {
                    Get.to(() => AddUomScreen());
                  },
                  context: context,
                ),
                drawerItem(
                  icon: Icons.inbox,
                  name: "Term's",
                  onTap: () {
                    Get.to(() => const TermMaster());
                  },
                  context: context,
                ),
              ],
              context: context,
            ),

            drawerItem(
              icon: Icons.task,
              name: "Task",
              onTap: () {
                Get.to(() => AppRoutes.tasks);
              },
              context: context,
            ),
            drawerItem(
              icon: Icons.logout,
              name: "Logout",
              onTap: () {
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
                        onPressed: () async {
                          // logout logic
                          await controller.signOut();
                          Get.back();
                          Get.offAllNamed('/login');
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                  barrierDismissible: false, // force user to pick
                );
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  // Widget drawerItem(IconData icon, String name, VoidCallback? onTap) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       child: Row(
  //         children: [
  //           Icon(icon, size: 30),
  //           const SizedBox(width: 10),
  //           Text(
  //             name,
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget drawerItemWithNestedRoutes(
  //   IconData icon,
  //   String name,
  //   List<Widget> children,
  // ) {
  //   return ExpansionTile(
  //     leading: Icon(icon, size: 30),
  //     title: Text(
  //       name,
  //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
  //     ),
  //     children: children,
  //   );
  // }

  Widget drawerItem({
    required IconData icon,
    required String name,
    required VoidCallback? onTap,
    required BuildContext context,
    bool isSelected = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      splashColor: colorScheme.primary.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItemWithNestedRoutes({
    required BuildContext context,
    required IconData icon,
    required String name,
    required List<Widget> children,
    bool isExpanded = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        leading: Icon(icon, size: 26, color: colorScheme.primary),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.onSurface.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        childrenPadding: const EdgeInsets.only(left: 40, bottom: 6),
        children: children,
      ),
    );
  }
}

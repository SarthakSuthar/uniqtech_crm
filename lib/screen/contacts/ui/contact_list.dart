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
                      // controller.searchNumResult(noController.text);
                      // controller.searchCustomerResult(searchController.text);
                      controller.searchResult(noController.text);
                      controller.searchResult(searchController.text);
                      showlog("Clear button pressed");
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
                      showlog("search button pressed");
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
                          no: controller.filterendList[index].uid ?? '',
                          customerName:
                              controller.filterendList[index].custName ?? '',
                          email: controller.filterendList[index].email ?? '',
                          mobileNo:
                              controller.filterendList[index].mobileNo ?? '',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showlog("Action button pressed");
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

  Widget contactListWidget({
    required String no,
    required String customerName,
    required String email,
    required String mobileNo,
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
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: InkWell(
                onTap: () {
                  showlog("edit button taped");
                  //pass uid
                  //get data for that uid
                  //maintain status for update or new
                  Get.toNamed(
                    AppRoutes.addContact,
                    arguments: {'isEdit': true, 'uid': no},
                  );
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
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

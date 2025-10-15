import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  final QuotesController controller = Get.put(QuotesController());
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
      appBar: appBar(title: "Quote"),
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
                  ? Text(" No data found")
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.filterendList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => quoteListWidget(
                          no: controller.filterendList[index].id.toString(),
                          email: controller.filterendList[index].email ?? '',
                          mobileNo:
                              controller.filterendList[index].mobileNo ?? '',
                          customerName:
                              controller.filterendList[index].custName1 ?? '',
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
          Get.toNamed(AppRoutes.addQuote, arguments: {'isEdit': false});
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

  Widget quoteListWidget({
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
                    onTap: () {
                      AppUtils.showlog("parsing arguments : $no");
                      Get.toNamed(
                        AppRoutes.addQuote,
                        arguments: {'no': no, 'isEdit': true},
                      );
                      AppUtils.showlog("edit button taped");
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
                    onTap: () async {
                      AppUtils.showlog("convert to order button taped");
                      await controller.convertQuotationToOrder(quotationId: no);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.logout_outlined,
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
                      AppUtils.showlog("copy quote button taped");
                      controller.copyQuotation(quotationId: no);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add_photo_alternate,
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
                      AppUtils.showlog("quote followup button taped");
                      AppUtils.showlog("Quote id passing from list: $no");
                      Get.toNamed(
                        AppRoutes.quotesFollowup,
                        arguments: {'quotationId': no},
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
                          Icons.edit_document,
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
                        AppRoutes.quotesInvoice,
                        arguments: {'quotationId': no},
                      );
                      // Get.toNamed(AppRoutes.quotesInvoice);
                      AppUtils.showlog("print document button taped");
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
                    onTap: () async {
                      await controller.deleteQuotation(id: int.parse(no));
                      AppUtils.showlog("delete button taped");
                    },
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

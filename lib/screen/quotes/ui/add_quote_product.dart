import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_const/utils/app_utils.dart';
import '../../../app_const/widgets/app_widgets.dart';

class AddQuoteProduct extends StatelessWidget {
  AddQuoteProduct({super.key});

  final QuotesController controller = Get.put(QuotesController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<QuotesController>();
          debugPrint("Route popped with result: $result");
        } else {
          debugPrint("Pop prevented!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => dropdownWidget(
                      hintText: "Select Product",
                      icon: Icons.business,
                      items: controller.productList.isEmpty
                          ? ["No Product Available"]
                          : controller.productList
                                .map((e) => e.productName!)
                                .toList(),
                      value: controller.selectedProduct?.value.isEmpty == true
                          ? null
                          : controller.selectedProduct?.value,
                      onChanged: controller.updateProduct,
                    ),
                  ),
                  //TODO: HAve to create UOM master
                  Row(
                    children: [
                      Obx(
                        () => dropdownWidget(
                          hintText: "Select UOM",
                          icon: Icons.business,
                          items: ["1", "2", "3"],
                          value: controller.selectedUOM?.value.isEmpty == true
                              ? null
                              : controller.selectedUOM?.value,
                          onChanged: controller.updateUOM,
                          expandInRow: true,
                        ),
                      ),
                      inputWidget(
                        hintText: "Quentity",
                        icon: Icons.numbers_outlined,
                        controller: controller.controllers["quntity"]!,
                        context: context,
                        focusNode: controller.focusNodes["quntity"]!,
                        keyboardType: TextInputType.number,
                        expandInRow: true,
                        onChanged: (val) => controller.calculateAmount(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      inputWidget(
                        hintText: "Rate",
                        icon: Icons.note,
                        controller: controller.controllers["rate"]!,
                        context: context,
                        focusNode: controller.focusNodes["rate"]!,
                        keyboardType: TextInputType.number,
                        expandInRow: true,
                        onChanged: (val) => controller.calculateAmount(),
                      ),
                      inputWidget(
                        hintText: "Discount",
                        icon: Icons.money,
                        controller: controller.controllers["discount"]!,
                        context: context,
                        focusNode: controller.focusNodes["discount"]!,
                        keyboardType: TextInputType.number,
                        expandInRow: true,
                        onChanged: (val) => controller.calculateAmount(),
                      ),
                    ],
                  ),
                  inputWidget(
                    hintText: "Amount",
                    icon: Icons.money,
                    controller: controller.controllers["amount"]!,
                    context: context,
                    focusNode: controller.focusNodes["amount"]!,
                    keyboardType: TextInputType.number,
                  ),
                  inputWidget(
                    hintText: "Remarks",
                    icon: Icons.money,
                    controller: controller.controllers["remarks"]!,
                    context: context,
                    focusNode: controller.focusNodes["remarks"]!,
                    minLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buttonWidget(
                        title: "ADD",
                        onTap: () async {
                          await controller.addQuotationProductID();
                          showlog("ADD :: Add inquirt customer");
                        },
                        context: context,
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.quotationProductList.isEmpty
                        ? const Text("no data for product ")
                        : ListView.builder(
                            itemCount: controller.quotationProductList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => addedProductListItem(
                              productName: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .quotationProductList[index]
                                            .productId,
                                  )
                                  .productName!,
                              quentity: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .quotationProductList[index]
                                            .productId,
                                  )
                                  .productUom!, // TODO: Add quentity and amount to QuotationProductModel
                              amount: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .quotationProductList[index]
                                            .productId,
                                  )
                                  .productRate!,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.isEdit == true
                  ? controller.updateQuotation()
                  : controller.submitQuotation();
              showlog("Inquiry Action button pressed");
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              controller.isEdit == true ? "Update" : "Save",
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget addedProductListItem({
    required String productName,
    required String quentity,
    required String amount,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Name"),
                Text("Quentity"),
                Text("Amount"),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Text(
                  quentity,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Text(amount, style: TextStyle(overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

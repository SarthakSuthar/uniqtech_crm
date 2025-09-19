import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/inquiry/controller/inquiry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddInquiryProduct extends StatelessWidget {
  AddInquiryProduct({super.key});

  final InquiryController controller = Get.put(InquiryController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<InquiryController>();
          debugPrint("Route popped with result: $result");
        } else {
          debugPrint("Pop prevented!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        hintText: "Amount",
                        icon: Icons.money,
                        controller: controller.controllers["amount"]!,
                        context: context,
                        focusNode: controller.focusNodes["amount"]!,
                        keyboardType: TextInputType.none,
                        expandInRow: true,
                      ),
                    ],
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
                          // await controller.submitInquiry();
                          // await controller.addProduct();
                          await controller.addInquiryProductID();
                          showlog("ADD :: Add inquirt customer");
                          // go back
                        },
                        context: context,
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.inquiryProductList.isEmpty
                        ? const Text("no data for product ")
                        : ListView.builder(
                            itemCount: controller.inquiryProductList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => addedProductListItem(
                              productName: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .inquiryProductList[index]
                                            .productId,
                                  )
                                  .productName!,
                              quentity: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .inquiryProductList[index]
                                            .productId,
                                  )
                                  .productUom!, // TODO: Add quentity and amount to InquiryProductModel
                              amount: controller.productList
                                  .firstWhere(
                                    (element) =>
                                        element.productId ==
                                        controller
                                            .inquiryProductList[index]
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
                  ? controller.updateInquiry()
                  : controller.submitInquiry();
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
              children: [Text("Product Name"), Text("Quentity"), Text("Rate")],
            ),
            const SizedBox(width: 30),
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

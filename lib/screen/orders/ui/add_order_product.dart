import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/orders/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrderProduct extends StatelessWidget {
  AddOrderProduct({super.key});

  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => dropdownWidget(
                hintText: "Select Product",
                icon: Icons.business,
                items: ["1", "2", "3"],
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
                ),
                inputWidget(
                  hintText: "Amount",
                  icon: Icons.money,
                  controller: controller.controllers["amount"]!,
                  context: context,
                  focusNode: controller.focusNodes["amount"]!,
                  keyboardType: TextInputType.number,
                  expandInRow: true,
                ),
              ],
            ),
            inputWidget(
              hintText: "Discount",
              icon: Icons.money,
              controller: controller.controllers["discount"]!,
              context: context,
              focusNode: controller.focusNodes["discount"]!,
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
                  onTap: () {
                    showlog("ADD :: Add Order customer");
                  },
                  context: context,
                ),
              ],
            ),
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => addedProductListItem(),
            ),
          ],
        ),
      ),
    );
  }

  Widget addedProductListItem() {
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
                Text("Product Name"),
                Text("Quentity"),
                Text("Amount"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

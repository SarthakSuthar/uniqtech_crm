import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Product"),
      drawer: const AppDrawer(),
      body: GestureDetector(
        onTap: () => controller.focusNodes.forEach((_, node) => node.unfocus()),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                inputWidget(
                  hintText: "Product Name",
                  icon: Icons.abc,
                  controller: controller.controllers["product_name"]!,
                  context: context,
                  focusNode: controller.focusNodes["product_name"]!,
                ),
                inputWidget(
                  hintText: "Product Code",
                  icon: Icons.abc,
                  controller: controller.controllers["product_code"]!,
                  context: context,
                  focusNode: controller.focusNodes["product_code"]!,
                ),
                Row(
                  children: [
                    inputWidget(
                      hintText: "Rate",
                      icon: Icons.money,
                      controller: controller.controllers["product_rate"]!,
                      context: context,
                      focusNode: controller.focusNodes["product_rate"]!,
                      keyboardType: TextInputType.number,
                      expandInRow: true,
                    ),
                    Obx(
                      () => dropdownWidget(
                        hintText: "UOM",
                        icon: Icons.abc,
                        items: ["1", "2", "3"],
                        value: controller.selectedUom?.value.isEmpty == true
                            ? null
                            : controller.selectedUom!.value,
                        onChanged: controller.updateUom,
                        expandInRow: true,
                      ),
                    ),
                  ],
                ),
                inputWidget(
                  hintText: "Description",
                  icon: Icons.note,
                  controller: controller.controllers["product_description"]!,
                  context: context,
                  focusNode: controller.focusNodes["product_description"]!,
                  minLines: 2,
                ),
                Obx(
                  () => Column(
                    children: controller.selectedFiles.map((file) {
                      return Card(
                        child: ListTile(
                          title: Text(file.path.split('/').last),
                          subtitle: Text(
                            "${((file.lengthSync()) / (1024 * 1024)).toStringAsFixed(2)} MB",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                controller.selectedFiles.remove(file),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                fileSelectWidget(
                  title: "Document",
                  icon: Icons.file_copy_outlined,
                  context: context,
                  onTap: () => controller.selectFiles(),
                ),
                if (controller.selectedImages.isNotEmpty)
                  Obx(
                    () => Column(
                      children: controller.selectedImages.map((file) {
                        return Card(
                          child: ListTile(
                            title: Text(file.path.split('/').last),
                            subtitle: Text(
                              "${((file.lengthSync()) / (1024 * 1024)).toStringAsFixed(2)} MB",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  controller.selectedImages.remove(file),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                fileSelectWidget(
                  title: "Image",
                  icon: Icons.image_outlined,
                  context: context,
                  onTap: () => controller.selectFiles(),
                ),

                // const Spacer(),
                const SizedBox(height: 20),
                buttonWidget(
                  title: "ADD",
                  onTap: () async {
                    showlog("ADD: Product");
                    await controller.addProduct();
                  },
                  context: context,
                ),

                Obx(
                  () => controller.products.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            return productListWidget(
                              code:
                                  controller.products[index].productCode ?? '',
                              name:
                                  controller.products[index].productName ?? '',
                              rate:
                                  controller.products[index].productRate ?? '',
                              uom: controller.products[index].productUom ?? '',
                            );
                          },
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productListWidget({
    required String code,
    required String name,
    required String rate,
    required String uom,
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
                      Text("Code"),
                      Row(children: [Text("Name"), const SizedBox(width: 20)]),
                      Text("Rate"),
                      Text("UOM"),
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(code),
                      Text(name),
                      Text(rate),
                      Text(uom),
                      const SizedBox(height: 20),
                    ],
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

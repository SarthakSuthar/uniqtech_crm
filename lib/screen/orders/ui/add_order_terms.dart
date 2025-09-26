import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/masters/terms/widget/add_task_popup.dart';
import 'package:crm/screen/orders/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrderTerms extends StatefulWidget {
  final String? orderId;
  final bool isEdit;
  const AddOrderTerms({super.key, this.orderId, required this.isEdit});

  @override
  State<AddOrderTerms> createState() => _AddOrderTermsState();
}

class _AddOrderTermsState extends State<AddOrderTerms> {
  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    controller.getAllTerms();
    controller.getSelectedTerms(int.parse(widget.orderId ?? '0'));
  }

  @override
  Widget build(BuildContext context) {
    widget.isEdit == true
        ? controller.isEdit = true
        : controller.isEdit = false;
    widget.orderId != null ? controller.no : controller.no = '';
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.allTerms.length,
            itemBuilder: (context, index) {
              final term = controller.allTerms[index];
              return Obx(
                () => termsTile(
                  title: term.title!,
                  // Get the state from the controller
                  isChecked: controller.selectedTerms.contains(term.id),
                  // Call the single, clean method on the controller
                  onChanged: () => controller.toggleTermSelection(term.id!),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonWidget(
                  title: "+ Add new term",
                  onTap: () async {
                    await addNewTerms(
                      context: context,
                      // onSave: (value) {
                      //   showlog("New term added : $value");
                      // },
                    );
                    await controller.getAllTerms();
                    await controller.getSelectedTerms(
                      int.parse(widget.orderId ?? '0'),
                    );
                  },
                  context: context,
                ),
                buttonWidget(
                  title: "Save",
                  onTap: () async {
                    await controller.addOrderTerms(
                      int.parse(controller.controllers['num']!.text),
                    );
                    showlog("Save :: Quote term");
                  },
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

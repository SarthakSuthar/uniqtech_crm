import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:crm/screen/masters/terms/widget/add_term_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotesTerms extends StatefulWidget {
  final String? quotationId;
  final bool isEdit;
  const QuotesTerms({super.key, this.quotationId, required this.isEdit});

  @override
  State<QuotesTerms> createState() => _QuotesTermsState();
}

class _QuotesTermsState extends State<QuotesTerms> {
  final QuotesController controller = Get.put(QuotesController());

  @override
  void initState() {
    super.initState();
    controller.getAllTerms();
    controller.getSelectedTerms(int.parse(widget.quotationId ?? '0'));
  }

  @override
  Widget build(BuildContext context) {
    widget.isEdit == true
        ? controller.isEdit = true
        : controller.isEdit = false;
    widget.quotationId != null ? controller.no : controller.no = '';
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
                      //   AppUtils.showlog("New term added : $value");
                      // },
                    );
                    await controller.getAllTerms();
                    await controller.getSelectedTerms(
                      int.parse(widget.quotationId ?? '0'),
                    );
                  },
                  context: context,
                ),
                buttonWidget(
                  title: "Save",
                  onTap: () async {
                    await controller.addQuotationTerms(
                      int.parse(controller.controllers['num']!.text),
                    );
                    AppUtils.showlog("Save :: Quote term");
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

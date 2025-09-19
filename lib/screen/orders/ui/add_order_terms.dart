import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/terms/widget/add_task_popup.dart';
import 'package:flutter/material.dart';

class AddOrderTerms extends StatelessWidget {
  const AddOrderTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) => termsTile(),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonWidget(
                  title: "+ Add new term",
                  onTap: () {
                    addNewTerms(
                      context: context,
                      // onSave: (value) {
                      //   showlog("New term added : $value");
                      // },
                    );
                  },
                  context: context,
                ),
                buttonWidget(
                  title: "Save",
                  onTap: () {
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

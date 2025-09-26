import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/screen/masters/terms/controller/terms_controller.dart';
import 'package:crm/screen/masters/terms/widget/add_task_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermMaster extends StatefulWidget {
  const TermMaster({super.key});

  @override
  State<TermMaster> createState() => _TermMasterState();
}

class _TermMasterState extends State<TermMaster> {
  final TermsController controller = Get.put(TermsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Terms"),
      body: Column(
        children: [
          Obx(() {
            return controller.allTerms.isEmpty
                ? Text("No terms available")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.allTerms.length,
                    itemBuilder: (context, index) {
                      final term = controller.allTerms[index];
                      return termDetails(
                        id: term.id!,
                        title: term.title!,
                        description: term.description!,
                      );
                    },
                  );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addNewTerms(context: context);
          controller.getAllTerms();
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget termDetails({
    required int id,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text(description),
          trailing: InkWell(
            onTap: () => controller.deleteTerm(id),
            child: Icon(Icons.delete, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

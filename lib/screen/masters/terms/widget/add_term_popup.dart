import 'package:crm/app_const/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:crm/screen/masters/terms/repo/terms_repo.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';

Future<void> addNewTerms({
  required BuildContext context,
  Function(String title, String description)? onSave,
}) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  await showDialog(
    barrierDismissible: false, // User must tap button to close
    context: context,
    builder: (context) {
      return Form(
        key: formKey,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Add New Term",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: "Enter Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            // Use TextButton for cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // close
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                AppUtils.showlog("Save button pressed");
                if (formKey.currentState!.validate()) {
                  if (titleController.text.trim().isNotEmpty &&
                      descriptionController.text.trim().isNotEmpty) {
                    final newTerm = TermsModel(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      isSynced: 0, // Assuming 0 means not synced
                    );
                    TermsRepo.insertTerms(newTerm);
                    if (onSave != null) {
                      onSave(
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                      );
                    }
                    Navigator.of(context).pop(); // close after save
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    },
  );
}

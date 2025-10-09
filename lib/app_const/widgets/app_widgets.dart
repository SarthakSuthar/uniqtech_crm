import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget inputWidget({
  required String hintText,
  required IconData icon,
  required TextEditingController controller,
  required BuildContext context,
  required FocusNode focusNode,
  void Function(String)? onChanged,
  int? minLines,
  TextInputType? keyboardType,
  bool expandInRow = false, // default safe for Column
  bool readOnly = false,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  final field = TextFormField(
    onChanged: onChanged,
    focusNode: focusNode,
    controller: controller,
    keyboardType: keyboardType ?? TextInputType.text,
    readOnly: readOnly,
    minLines: minLines ?? 1,
    maxLines: minLines == null ? 1 : minLines + 1,
    decoration: InputDecoration(
      labelText: hintText,
      prefixIcon: Icon(icon),
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 14,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return "This field is required";
      return null;
    },
  );

  if (expandInRow) {
    // ✅ Expanded directly in Row
    return Expanded(
      child: Padding(padding: const EdgeInsets.all(8.0), child: field),
    );
  } else {
    // ✅ Safe for Column / ScrollView
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(width: screenWidth * 0.9, child: field),
    );
  }
}

Widget dropdownWidget({
  required String hintText,
  required IconData icon,
  required List<String> items,
  String? value,
  required Function(String?) onChanged,
  bool expandInRow = false,
}) {
  final dropdown = Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField<String>(
      isExpanded: true, // ✅ fixes text overflow
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      hint: Text(
        hintText,
        overflow: TextOverflow.ellipsis, // ✅ ellipsis on hint
        maxLines: 1,
        // style: const TextStyle(color: Colors.grey),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis, // ✅ ellipsis on items too
            maxLines: 1,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );

  // ✅ Prevents unbounded width issues in Row
  return expandInRow ? Expanded(child: dropdown) : dropdown;
}

Widget buttonWidget({
  required String title,
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget datePickerWidget({
//   required IconData icon,
//   required TextEditingController controller,
//   required BuildContext context,
//   bool expandInRow = false,
// }) {
//   final dateFormat = DateFormat("d/M/yyyy");

//   final dateField = Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: TextFormField(
//       controller: controller,
//       readOnly: true,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon),
//         hintText: dateFormat.format(DateTime.now()),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       onTap: () async {
//         DateTime initialDate;

//         // If controller is empty, set initialDate to today's date
//         if (controller.text.isEmpty) initialDate = DateTime.now();

//         if (controller.text.isNotEmpty) {
//           try {
//             initialDate = dateFormat.parse(controller.text);
//           } catch (_) {
//             initialDate = DateTime.now();
//           }
//         } else {
//           initialDate = DateTime.now();
//         }

//         final DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: initialDate,
//           firstDate: DateTime(1900),
//           lastDate: DateTime(2100),
//         );

//         if (picked != null) {
//           controller.text = dateFormat.format(picked);
//         } else if (controller.text.isEmpty) {
//           // 👇 if user cancels and it's still empty, set today's date
//           controller.text = dateFormat.format(DateTime.now());
//         }
//       },
//     ),
//   );

//   return expandInRow ? Expanded(child: dateField) : dateField;
// }

Widget datePickerWidget({
  required IconData icon,
  required TextEditingController controller,
  required BuildContext context,
  bool expandInRow = false,
}) {
  final dateFormat = DateFormat("dd/MM/yyyy");

  // Set controller text to today if empty
  if (controller.text.isEmpty) {
    controller.text = dateFormat.format(DateTime.now());
  }

  final dateField = Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        // You can remove hintText now; controller.text will show the date
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onTap: () async {
        DateTime initialDate = DateTime.now();

        try {
          initialDate = dateFormat.parseStrict(controller.text);
        } catch (e) {
          debugPrint("Date parse failed: $e");
          initialDate = DateTime.now();
        }

        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          controller.text = dateFormat.format(picked);
        }
      },
    ),
  );

  return expandInRow ? Expanded(child: dateField) : dateField;
}

Widget termsTile({
  required String title,
  required bool isChecked,
  required VoidCallback onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: ListTile(
        leading: Checkbox(value: isChecked, onChanged: (_) => onChanged()),
        title: Text(title),
        onTap: onChanged,
      ),
    ),
  );
}

Widget fileSelectWidget({
  required BuildContext context,
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: DottedBorder(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(icon, size: 30),
                  Text(
                    "Select $title",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

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
      filled: true,
      fillColor: Colors.white,
      labelText: hintText,
      prefixIcon: Icon(icon),
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 14,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return "This field is required";
      }
      return null;
    },
  );

  // final widgetWithPadding = Padding(
  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //   child: SizedBox(
  //     width: expandInRow ? null : screenWidth * 0.9,
  //     child: Material(
  //       elevation: 1,
  //       borderRadius: BorderRadius.circular(14),
  //       shadowColor: Colors.black12,
  //       child: field,
  //     ),
  //   ),
  // );

  // return expandInRow ? Expanded(child: widgetWithPadding) : widgetWithPadding;

  if (expandInRow) {
    return Expanded(
      child: Padding(padding: const EdgeInsets.all(8.0), child: field),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(width: screenWidth * 0.9, child: field),
    );
  }
}

// Widget inputWidget({
//   required String hintText,
//   required IconData icon,
//   required TextEditingController controller,
//   required BuildContext context,
//   required FocusNode focusNode,
//   void Function(String)? onChanged,
//   int? minLines,
//   TextInputType? keyboardType,
//   bool expandInRow = false,
//   bool readOnly = false,
// }) {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final colorScheme = Theme.of(context).colorScheme;

//   final field = TextFormField(
//     onChanged: onChanged,
//     focusNode: focusNode,
//     controller: controller,
//     keyboardType: keyboardType ?? TextInputType.text,
//     readOnly: readOnly,
//     minLines: minLines ?? 1,
//     maxLines: minLines == null ? 1 : minLines + 1,
//     style: TextStyle(
//       fontSize: 16,
//       color: colorScheme.onSurface,
//       fontWeight: FontWeight.w500,
//     ),
//     decoration: InputDecoration(
//       labelText: hintText,
//       prefixIcon: Icon(
//         icon,
//         color: focusNode.hasFocus
//             ? colorScheme.primary
//             : colorScheme.onSurface.withOpacity(0.6),
//       ),
//       filled: true,
//       fillColor: colorScheme.surface.withOpacity(0.9),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

//       // Borders
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: colorScheme.error, width: 1.5),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: colorScheme.error, width: 1.5),
//       ),

//       // Floating label behavior
//       floatingLabelStyle: TextStyle(
//         color: colorScheme.primary,
//         fontWeight: FontWeight.w600,
//       ),
//       hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 15),
//     ),
//     validator: (value) {
//       if (value == null || value.trim().isEmpty) {
//         return "This field is required";
//       }
//       return null;
//     },
//   );

//   final widgetWithPadding = Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     child: SizedBox(
//       width: expandInRow ? null : screenWidth * 0.9,
//       child: Material(
//         elevation: 1,
//         borderRadius: BorderRadius.circular(14),
//         shadowColor: Colors.black12,
//         child: field,
//       ),
//     ),
//   );

//   return expandInRow ? Expanded(child: widgetWithPadding) : widgetWithPadding;
// }

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
        filled: true,
        fillColor: Colors.white,
        // labelText: hintText,
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
      validator: (value) {
        if (value == null || value.isEmpty) return "This field is required";
        return null;
      },
    ),
  );

  return expandInRow ? Expanded(child: dropdown) : dropdown;
}

// Widget dropdownWidget({
//   required String hintText,
//   required IconData icon,
//   required List<String> items,
//   String? value,
//   required Function(String?) onChanged,
//   bool expandInRow = false,
// }) {
//   final dropdown = Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//     child: DropdownButtonFormField<String>(
//       isExpanded: true,
//       value: value,
//       decoration: InputDecoration(
//         labelText: hintText,
//         labelStyle: const TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.grey,
//         ),
//         prefixIcon: Icon(icon, color: Colors.blueAccent),
//         // ✅ Visible rounded border
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: Color(0xFFB0BEC5), // Light grey border
//             width: 1.3,
//           ),
//         ),
//         // ✅ Border color when focused
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//       dropdownColor: Colors.white,
//       icon: const Icon(
//         Icons.keyboard_arrow_down_rounded,
//         color: Colors.blueAccent,
//       ),
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         color: Colors.black87,
//       ),
//       hint: Text(
//         hintText,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(color: Colors.grey),
//       ),
//       items: items.map((item) {
//         return DropdownMenuItem(
//           value: item,
//           child: Text(
//             item,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(fontWeight: FontWeight.w500),
//           ),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: (value) {
//         if (value == null || value.isEmpty) return "This field is required";
//         return null;
//       },
//     ),
//   );

//   return expandInRow ? Expanded(child: dropdown) : dropdown;
// }

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
        filled: true,
        fillColor: Colors.white,
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

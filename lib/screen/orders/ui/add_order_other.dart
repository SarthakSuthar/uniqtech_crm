import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/orders/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrderOther extends StatefulWidget {
  const AddOrderOther({super.key});

  @override
  State<AddOrderOther> createState() => _AddOrderOtherState();
}

class _AddOrderOtherState extends State<AddOrderOther> {
  final OrderController controller = Get.put(OrderController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              inputWidget(
                hintText: "Supplier Reference",
                icon: Icons.person,
                controller: controller.controllers["supplier_ref"]!,
                context: context,
                focusNode: controller.focusNodes["supplier_ref"]!,
              ),
              inputWidget(
                hintText: "Other Reference",
                icon: Icons.group,
                controller: controller.controllers["other_ref"]!,
                context: context,
                focusNode: controller.focusNodes["other_ref"]!,
              ),
              inputWidget(
                hintText: "Extra Discount",
                icon: Icons.money,
                controller: controller.controllers["extra_discount"]!,
                context: context,
                focusNode: controller.focusNodes["extra_discount"]!,
                keyboardType: TextInputType.number,
              ),
              inputWidget(
                hintText: "Freight Amount",
                icon: Icons.money,
                controller: controller.controllers['freight_amount']!,
                context: context,
                focusNode: controller.focusNodes['freight_amount']!,
                keyboardType: TextInputType.number,
              ),
              inputWidget(
                hintText: "Loading Charges",
                icon: Icons.money,
                controller: controller.controllers['loading_charges']!,
                context: context,
                focusNode: controller.focusNodes['loading_charges']!,
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buttonWidget(
                    title: "Next",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        DefaultTabController.of(context).animateTo(2);
                      }
                    },
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

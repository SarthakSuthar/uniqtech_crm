import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/app_const/widgets/app_widgets.dart';
import 'package:crm/screen/masters/uom/controller/uom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUomScreen extends StatelessWidget {
  AddUomScreen({super.key});

  final UomController controller = Get.put(UomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add UOM')),
      drawer: const AppDrawer(),
      body: GestureDetector(
        onTap: () {
          controller.uomNameFocusNode.unfocus();
          controller.uomCodeFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputWidget(
                  hintText: "UOM Name",
                  icon: Icons.abc,
                  controller: controller.uomNameController,
                  context: context,
                  focusNode: controller.uomNameFocusNode,
                ),
                inputWidget(
                  hintText: "UOM Code",
                  icon: Icons.abc,
                  controller: controller.uomCodeController,
                  context: context,
                  focusNode: controller.uomCodeFocusNode,
                ),

                buttonWidget(
                  title: "Add",
                  onTap: () {
                    controller.insertUom();
                  },
                  context: context,
                ),
                const SizedBox(height: 20),
                Text(
                  "Available UOM",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => controller.allUoms.isEmpty
                      ? Text("No Data Found")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.allUoms.length,
                          itemBuilder: (context, index) {
                            return uomList(
                              id: controller.allUoms[index].id!,
                              name: controller.allUoms[index].name!,
                              code: controller.allUoms[index].code!,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uomList({
    required int id,
    required String name,
    required String code,
  }) {
    return Card(
      child: ListTile(
        // leading: Text(id.toString(), style: TextStyle(fontSize: 20)),
        title: Text("Name: $name", style: TextStyle(fontSize: 20)),
        subtitle: Text("Code: $code"),
        trailing: IconButton(
          onPressed: () {
            controller.deleteUom(id);
          },
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}

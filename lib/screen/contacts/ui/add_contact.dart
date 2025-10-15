import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/screen/contacts/ui/add_customer_contact.dart';
import 'package:crm/screen/contacts/ui/add_customer_form.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AddContactScreen extends StatefulWidget {
  final String uid;
  final bool isEdit;
  const AddContactScreen({super.key, required this.uid, required this.isEdit});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Contacts"),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                isScrollable: false,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Tab(text: "Customer"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Tab(text: "Contact"),
                  ),
                ],
                labelColor: Theme.of(context).canvasColor, // background color
                unselectedLabelColor: Theme.of(context).primaryColor,
                indicator: RectangularIndicator(
                  bottomLeftRadius: 10, // Adjust radius as needed
                  bottomRightRadius: 10, // Adjust radius as needed
                  topLeftRadius: 10, // Adjust radius as needed
                  topRightRadius: 10, // Adjust radius as needed
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SizedBox(
                      child: AddCustomerForm(
                        isEdit: widget.isEdit,
                        uid: widget.uid,
                      ),
                    ),
                    SizedBox(
                      child: AddCustomerContactScreen(
                        isEdit: widget.isEdit,
                        uid: widget.uid,
                      ),
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
}

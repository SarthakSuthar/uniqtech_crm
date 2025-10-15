import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/screen/inquiry/ui/add_inquiry_customer.dart';
import 'package:crm/screen/inquiry/ui/add_inquiry_product.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AddInquiryScreen extends StatefulWidget {
  final String? no;
  final bool isEdit;
  const AddInquiryScreen({super.key, this.no, required this.isEdit});

  @override
  State<AddInquiryScreen> createState() => _AddInquiryScreenState();
}

class _AddInquiryScreenState extends State<AddInquiryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Inquiry"),
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
                    child: const Tab(text: "Product"),
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
                      child: AddInquiryCustomer(
                        no: widget.no,
                        isEdit: widget.isEdit,
                      ),
                    ),
                    SizedBox(child: AddInquiryProduct()),
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

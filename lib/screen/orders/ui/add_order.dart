import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/screen/orders/ui/add_order_customer.dart';
import 'package:crm/screen/orders/ui/add_order_other.dart';
import 'package:crm/screen/orders/ui/add_order_product.dart';
import 'package:crm/screen/orders/ui/add_order_terms.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AddOrder extends StatelessWidget {
  final String? no;
  final bool isEdit;

  const AddOrder({super.key, this.no, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Order"),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTabController(
          length: 4,
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
                    child: const Tab(text: "Other"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Tab(text: "Product"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Tab(text: "Term's"),
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
                      child: AddOrderCustomer(no: no, isEdit: isEdit),
                    ),
                    SizedBox(child: AddOrderOther()),
                    SizedBox(child: AddOrderProduct()),
                    SizedBox(
                      child: AddOrderTerms(orderId: no, isEdit: isEdit),
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

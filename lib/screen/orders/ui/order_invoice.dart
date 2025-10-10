import 'package:crm/screen/orders/controller/order_controller.dart';
import 'package:crm/screen/orders/models/order_invoice_model.dart';
import 'package:crm/screen/orders/models/order_terms_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:crm/app_const/widgets/app_drawer.dart';

class OrderInvoice extends StatefulWidget {
  const OrderInvoice({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderInvoice> createState() => _OrderInvoiceState();
}

class _OrderInvoiceState extends State<OrderInvoice> {
  final dateFormat = DateFormat("dd/MM/yyyy");

  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    controller.setOrderInvoiceDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Invoice")),
      drawer: AppDrawer(),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        // allowPrinting: false,
        // allowSharing: false,
        canDebug: false,
        actions: const [],
        build: (context) => generateInvoicePdf(
          invoiceNumber: "INV-001",
          customerName: controller.invoiceCustName.value,
          customerContact: controller.invoiceCustContact.value,
          customerEmail: controller.invoiceCustEmail.value,
          extraDiscount: controller.extraDiscount.value,
          freightAmount: controller.freightAmount.value,
          loadCharge: controller.loadingCharges.value,
          suppRef: controller.suppRef.value,
          otherRef: controller.otherRef.value,
          items: controller.invoiceProductList,
          terms: controller.invoiceTermsList,
        ),
      ),
    );
  }

  Future<Uint8List> generateInvoicePdf({
    required String invoiceNumber,
    required String customerName,
    required String customerContact,
    required String customerEmail,
    required String extraDiscount,
    required String freightAmount,
    required String loadCharge,
    required String suppRef,
    required String otherRef,
    required List<ProductItem> items,
    required List<OrderTermsModel> terms,
  }) async {
    final pdf = pw.Document();

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    final totalAmount = items.fold(
      0.0,
      (sum, item) => sum + (item.amount as num),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (context) => [
          // Header
          pw.Header(
            level: 2,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "INVOICE",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Image(logo, width: 150),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Company & Invoice Info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("UniqTech Solutions"),
                  pw.Text("211 388001 Gujarat"),
                  pw.Text("Contact No: 989456521"),
                  pw.Text("Email: mikir@uniqtechsolutions.com"),
                  pw.Text("uniqtechsolutions.com"),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Invoice No: 1"),
                  pw.Text(dateFormat.format(DateTime.now())),
                  pw.Text("Modes/Terms of Payment:"),
                  pw.Text("Supplier: $suppRef"),
                  pw.Text("Other References: $otherRef"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Buyer Info
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Buyer:"),
              pw.Text(customerName),
              pw.Text("Contact No: $customerContact"),
              pw.Text("Email: $customerEmail"),
            ],
          ),
          pw.SizedBox(height: 16),

          // Table of Items
          pw.TableHelper.fromTextArray(
            headers: [
              "Sr No",
              "Product Name",
              "Qty",
              "Alt",
              "Rate",
              "Dis(%)",
              "Dis2(%)",
              "Amount",
            ],
            data: items
                .map(
                  (e) => [
                    items.indexOf(e) + 1,
                    e.itemName,
                    e.qty,
                    e.altAmt,
                    e.rate,
                    e.disc1,
                    e.disc2,
                    e.amount,
                  ],
                )
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
          ),
          pw.SizedBox(height: 16),

          // Totals
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Total:",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      totalAmount.toStringAsFixed(4),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Extra Dis.(%):",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "CGST(0%):",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "SGST(0%):",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "IGST(0%):",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Freight Amount:",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Load Charge:",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Sub Total:",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      "21240.0",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Declaration & Bank Details
          pw.Text(
            "Declaration:\nWe declare that this invoice shows the actual price of the goods described and that all particulars are true and correct.",
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Company's Bank Details:\nBank Name: Kotak Mahindra\nBank A/C No.: 4912105020\nBank & IFSC Code: Alkapuri & KKBK0000841",
          ),
          pw.SizedBox(height: 16),

          // Signature
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Customer Seal and Signature"),
              pw.Text("For Uniqtech Solutions\nAuthorized Signatory"),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }
}

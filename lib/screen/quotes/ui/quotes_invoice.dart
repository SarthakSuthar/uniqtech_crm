import 'package:crm/app_const/theme/app_theme.dart';
import 'package:crm/app_const/widgets/app_drawer.dart';
import 'package:crm/screen/quotes/controller/quotes_controller.dart';
import 'package:crm/screen/quotes/model/quotation_terms_model.dart';
import 'package:crm/screen/quotes/model/quote_invoice_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';
import 'package:crm/app_const/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class QuotesInvoice extends StatefulWidget {
  const QuotesInvoice({super.key, required this.quotationId});

  final String quotationId;

  @override
  State<QuotesInvoice> createState() => _QuotesInvoiceState();

  static Future<Uint8List> generate({
    required String invoiceNumber,
    required String customerName,
    required String customerAddress,
    required String subject,
    required String date,
    required List<ProductItem> items,
    required List<QuotationTermsModel> terms,
    required String amount,
    required String hsn,
  }) async {
    final pdf = pw.Document();

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logo, width: 150),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "SF - 211, Park Plaza,\nNr. Kunal Crossing, Samta - Subhanpura,\nVadodara - 390023, Gujarat, India.",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        fontSize: 9,
                        lineSpacing: 1.2,
                        color: PdfColor.fromInt(AppTheme.primaryColor.value),
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      "mikir@uniqtechsolutions.com",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColor.fromInt(AppTheme.primaryColor.value),
                      ),
                    ),
                    pw.Text(
                      "www.uniqtechsolutions.com",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColor.fromInt(AppTheme.primaryColor.value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(invoiceNumber),
          pw.Text(date),
          pw.Text("To,"),
          pw.Text(customerName),
          pw.Text(customerAddress),

          pw.SizedBox(height: 20),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Quotation For $subject",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(AppTheme.primaryColor.value),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Dear Sir,\nThis has refrence to the discussion with regarding the above mentioned subject.\nWe are pleased to offer our lowest pricees for same.",
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Value Chart",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(AppTheme.primaryColor.value),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(
              color: PdfColor.fromInt(AppTheme.primaryColor.value),
              style: pw.BorderStyle.dashed,
            ),
            headers: [
              'Sr. No',
              'Item Name',
              'Qty',
              'Rate',
              'Amt',
              'HSN',
              'GST(%)',
            ],
            data: items
                .map(
                  (e) => [
                    items.indexOf(e) + 1,
                    e.itemName,
                    e.itemQty,
                    e.itemRate,
                    e.itemAmount,
                    e.itemHsn,
                    e.gst,
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 10),
          buildTermsAndConditionsSection(),
          pw.SizedBox(height: 10),
          pw.Text(
            "for Uniqtech Solutions",
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            "MIKIR PAREKH",
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            "CEO",
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            "+91 8320604985",
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget buildTermsAndConditionsSection() {
    final terms = {
      "Prices": "At Ex-Vadodara our office.",
      "Warranty Terms":
          "Warranty applicable as per the terms of manufacturer company.",
      "Payment": "Against Delivery",
      "Validity": "7 Days (Period Valid).",
      "Taxes": "As Applicable.",
      "Pan No": "AEQPS7198D",
      "MSME": "GJ25D000021",
      "P.F No": "GJ/47168",
      "ESIC No": "3906110",
      "GSTIN": "24AEQPS7198D1ZW",
      "Transportation Charges": "Charges At Actual.",
    };

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'Terms & Conditions',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(AppTheme.primaryColor.value),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          ...terms.entries.map(
            (entry) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120, // left column width
                    child: pw.Text(
                      entry.key,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Text(
                      entry.value,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotesInvoiceState extends State<QuotesInvoice> {
  final QuotesController controller = Get.put(QuotesController());
  final dateFormat = DateFormat("dd/MM/yyyy");
  @override
  void initState() {
    super.initState();
    controller.setQuoteInvoiceData(widget.quotationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Quotation Invoice"),
      drawer: AppDrawer(),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        // allowPrinting: false,
        // allowSharing: false,
        canDebug: false,
        actions: const [],
        build: (context) => QuotesInvoice.generate(
          invoiceNumber: "INV-001",
          customerName: controller.invoiceCustName.value,
          customerAddress: controller.invoiceCustAddress.value,
          subject: controller.invoiceSubject.value,
          date: dateFormat.format(DateTime.now()),
          items: controller.invoiceProductList,
          amount: "00",
          terms: controller.invoiceTermsList,
          hsn: '000',
        ),
      ),
    );
  }
}

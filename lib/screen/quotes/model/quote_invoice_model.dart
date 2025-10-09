class QuotationInvoiceModel {
  String? custName;
  String? custAddress;
  String? subject;
  List<ProductItem>? productList;
  List<String>? termsList;

  QuotationInvoiceModel({
    this.custName,
    this.custAddress,
    this.subject,
    this.productList,
    this.termsList,
  });

  factory QuotationInvoiceModel.fromJson(Map<String, dynamic> json) {
    return QuotationInvoiceModel(
      custName: json['custName'],
      custAddress: json['custAddress'],
      subject: json['subject'],
      productList: (json['productList'] as List<dynamic>?)
          ?.map((e) => ProductItem.fromJson(e))
          .toList(),
      termsList: (json['termsList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custName': custName,
      'custAddress': custAddress,
      'subject': subject,
      'productList': productList?.map((e) => e.toJson()).toList(),
      'termsList': termsList,
    };
  }
}

class ProductItem {
  String? itemName;
  int? itemQty;
  double? itemRate;
  double? itemAmount;
  String? itemHsn;
  double? gst; // Default 18%

  ProductItem({
    this.itemName,
    this.itemQty,
    this.itemRate,
    this.itemAmount,
    this.itemHsn,
    this.gst = 18.0,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      itemName: json['itemName'],
      itemQty: json['itemQty'],
      itemRate: (json['itemRate'] as num?)?.toDouble(),
      itemAmount: (json['itemAmount'] as num?)?.toDouble(),
      itemHsn: json['itemHsn'],
      gst: (json['gst'] as num?)?.toDouble() ?? 18.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemQty': itemQty,
      'itemRate': itemRate,
      'itemAmount': itemAmount,
      'itemHsn': itemHsn,
      'gst': gst,
    };
  }
}

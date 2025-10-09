class OrderInvoiceModel {
  String? custName;
  String? custContact;
  String? custEmail;
  double? extraDiscount;
  double? freightAmount;
  double? loadCharges;
  String? supplierRef;
  String? otherRef;
  List<ProductItem>? productList;
  List<TermItem>? termsList;

  OrderInvoiceModel({
    this.custName,
    this.custContact,
    this.custEmail,
    this.extraDiscount,
    this.freightAmount,
    this.loadCharges,
    this.supplierRef,
    this.otherRef,
    this.productList,
    this.termsList,
  });

  factory OrderInvoiceModel.fromJson(Map<String, dynamic> json) {
    return OrderInvoiceModel(
      custName: json['custName'],
      custContact: json['custContact'],
      custEmail: json['custEmail'],
      extraDiscount: (json['extraDiscount'] as num?)?.toDouble(),
      freightAmount: (json['freightAmount'] as num?)?.toDouble(),
      loadCharges: (json['loadCharges'] as num?)?.toDouble(),
      supplierRef: json['supplierRef'],
      otherRef: json['otherRef'],
      productList: (json['productList'] as List<dynamic>?)
          ?.map((e) => ProductItem.fromJson(e))
          .toList(),
      termsList: (json['termsList'] as List<dynamic>?)
          ?.map((e) => TermItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custName': custName,
      'custContact': custContact,
      'custEmail': custEmail,
      'extraDiscount': extraDiscount,
      'freightAmount': freightAmount,
      'loadCharges': loadCharges,
      'supplierRef': supplierRef,
      'otherRef': otherRef,
      'productList': productList?.map((e) => e.toJson()).toList(),
      'termsList': termsList?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductItem {
  String? itemName;
  int? qty;
  double? altAmt;
  double? rate;
  double? disc1;
  double? disc2;
  double? amount;

  ProductItem({
    this.itemName,
    this.qty,
    this.altAmt,
    this.rate,
    this.disc1,
    this.disc2,
    this.amount,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      itemName: json['itemName'],
      qty: json['qty'],
      altAmt: (json['altAmt'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      disc1: (json['disc1'] as num?)?.toDouble(),
      disc2: (json['disc2'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'qty': qty,
      'altAmt': altAmt,
      'rate': rate,
      'disc1': disc1,
      'disc2': disc2,
      'amount': amount,
    };
  }
}

class TermItem {
  String? termsOfDelivery;

  TermItem({this.termsOfDelivery});

  factory TermItem.fromJson(Map<String, dynamic> json) {
    return TermItem(termsOfDelivery: json['termsOfDelivery']);
  }

  Map<String, dynamic> toJson() {
    return {'termsOfDelivery': termsOfDelivery};
  }
}

class OrderModel {
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? updatedBy;
  int? custId;
  String? custName1;
  // String? custName2;
  String? date;
  String? email;
  String? mobileNo;
  String? source;
  String? supplierRef;
  String? otherRef;
  double? extraDiscount;
  String? freightAmount;
  String? loadingCharges;
  int isSynced;

  OrderModel({
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.custId,
    this.custName1,
    // this.custName2,
    this.date,
    this.email,
    this.mobileNo,
    this.source,
    this.supplierRef,
    this.otherRef,
    this.extraDiscount = 0.0,
    this.freightAmount,
    this.loadingCharges,
    this.isSynced = 0,
  });

  /// Convert model to JSON (for database or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'custId': custId,
      'cust_name1': custName1,
      // 'cust_name2': custName2,
      'date': date,
      'email': email,
      'mobile_no': mobileNo,
      'source': source,
      'supplier_ref': supplierRef,
      'other_ref': otherRef,
      'extra_discount': extraDiscount,
      'freight_amount': freightAmount,
      'loading_charges': loadingCharges,
      'isSynced': isSynced,
    };
  }

  /// Create model instance from JSON (from API or database)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
      custId: json['custId'],
      custName1: json['cust_name1'],
      // custName2: json['cust_name2'],
      date: json['date'],
      email: json['email'],
      mobileNo: json['mobile_no'],
      source: json['source'],
      supplierRef: json['supplier_ref'],
      otherRef: json['other_ref'],
      extraDiscount: (json['extra_discount'] ?? 0.0).toDouble(),
      freightAmount: json['freight_amount'],
      loadingCharges: json['loading_charges'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id,  custId: $custId, custName1: $custName1, date: $date, email: $email, mobileNo: $mobileNo, source: $source, supplierRef: $supplierRef, otherRef: $otherRef, extraDiscount: $extraDiscount, freightAmount: $freightAmount, loadingCharges: $loadingCharges, isSynced: $isSynced)';
  }
}

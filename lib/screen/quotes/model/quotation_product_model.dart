class QuotationProductModel {
  int? id;
  int quotationId;
  int productId;
  int? quantity;
  double discount;
  String? remark;
  int isSynced;

  QuotationProductModel({
    this.id,
    required this.quotationId,
    required this.productId,
    this.quantity,
    this.discount = 0.0,
    this.remark,
    this.isSynced = 0,
  });

  /// Convert model to JSON (for database or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quotationId': quotationId,
      'productId': productId,
      'quantity': quantity,
      'discount': discount,
      'remark': remark,
      'isSynced': isSynced,
    };
  }

  /// Create model from JSON (from API or database)
  factory QuotationProductModel.fromJson(Map<String, dynamic> json) {
    return QuotationProductModel(
      id: json['id'],
      quotationId: json['quotationId'],
      productId: json['productId'],
      quantity: json['quantity'],
      discount: (json['discount'] ?? 0.0).toDouble(),
      remark: json['remark'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'QuotationProductModel(id: $id, quotationId: $quotationId, productId: $productId, quantity: $quantity, discount: $discount, remark: $remark, isSynced: $isSynced)';
  }
}

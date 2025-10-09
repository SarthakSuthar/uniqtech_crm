class InquiryProductModel {
  int? id;
  int inquiryId;
  int productId;
  int quantity;
  String? remark;
  int isSynced;

  InquiryProductModel({
    this.id,
    required this.inquiryId,
    required this.productId,
    required this.quantity,
    this.remark,
    this.isSynced = 0,
  });

  /// Convert model to JSON (for saving or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inquiryId': inquiryId,
      'productId': productId,
      'quantity': quantity,
      'remark': remark,
      'isSynced': isSynced,
    };
  }

  /// Create model instance from JSON (from API or DB)
  factory InquiryProductModel.fromJson(Map<String, dynamic> json) {
    return InquiryProductModel(
      id: json['id'],
      inquiryId: json['inquiryId'],
      productId: json['productId'],
      quantity: json['quantity'],
      remark: json['remark'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'InquiryProductModel(id: $id, inquiryId: $inquiryId, productId: $productId, quantity: $quantity, remark: $remark, isSynced: $isSynced)';
  }
}

class InquiryProductModel {
  int? id;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int inquiryId;
  int productId;
  int quantity;
  String? remark;
  int isSynced;

  InquiryProductModel({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
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
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

class OrderProductModel {
  int? id;
  int orderId;
  int productId;
  int quantity;
  double discount;
  String? remark;
  int isSynced;

  OrderProductModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    this.discount = 0.0,
    this.remark,
    this.isSynced = 0,
  });

  /// Convert model to JSON (for database or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'discount': discount,
      'remark': remark,
      'isSynced': isSynced,
    };
  }

  /// Create model from JSON (from API or database)
  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      discount: (json['discount'] ?? 0.0).toDouble(),
      remark: json['remark'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'OrderProductModel(id: $id, orderId: $orderId, productId: $productId, quantity: $quantity, discount: $discount, remark: $remark, isSynced: $isSynced)';
  }
}

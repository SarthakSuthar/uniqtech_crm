// To parse this JSON data, do
//
//     final orderProductModel = orderProductModelFromJson(jsonString);

import 'dart:convert';

OrderProductModel orderProductModelFromJson(String str) =>
    OrderProductModel.fromJson(json.decode(str));

String orderProductModelToJson(OrderProductModel data) =>
    json.encode(data.toJson());

class OrderProductModel {
  int? id;
  int? orderId;
  int? productId;
  int? quentity;
  int? isSynced = 0;

  OrderProductModel({
    this.id,
    this.orderId,
    this.productId,
    this.quentity,
    this.isSynced,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        id: json["id"],
        orderId: json["orderId"],
        productId: json["productId"],
        quentity: json["quentity"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "productId": productId,
    "quentity": quentity,
    "isSynced": isSynced,
  };
}

// To parse this JSON data, do
//
//     final orderTermsModel = orderTermsModelFromJson(jsonString);

import 'dart:convert';

OrderTermsModel orderTermsModelFromJson(String str) =>
    OrderTermsModel.fromJson(json.decode(str));

String orderTermsModelToJson(OrderTermsModel data) =>
    json.encode(data.toJson());

class OrderTermsModel {
  int? id;
  int? orderId;
  int? termId;
  int? isSynced = 0;

  OrderTermsModel({this.id, this.orderId, this.termId, this.isSynced});

  factory OrderTermsModel.fromJson(Map<String, dynamic> json) =>
      OrderTermsModel(
        id: json["id"],
        orderId: json["orderId"],
        termId: json["termId"],
        isSynced: json["isSynced"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "termId": termId,
    "isSynced": isSynced ?? 0,
  };
}

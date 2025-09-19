// To parse this JSON data, do
//
//     final quotationProductModel = quotationProductModelFromJson(jsonString);

import 'dart:convert';

QuotationProductModel quotationProductModelFromJson(String str) =>
    QuotationProductModel.fromJson(json.decode(str));

String quotationProductModelToJson(QuotationProductModel data) =>
    json.encode(data.toJson());

class QuotationProductModel {
  int? id;
  int? quotationId;
  int? productId;
  int? quentity;
  int? isSynced = 0;

  QuotationProductModel({
    this.id,
    this.quotationId,
    this.productId,
    this.quentity,
    this.isSynced,
  });

  factory QuotationProductModel.fromJson(Map<String, dynamic> json) =>
      QuotationProductModel(
        id: json["id"],
        quotationId: json["quotationId"],
        productId: json["productId"],
        quentity: json["quentity"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quotationId": quotationId,
    "productId": productId,
    "quentity": quentity,
    "isSynced": isSynced,
  };
}

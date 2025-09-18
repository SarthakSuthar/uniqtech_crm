// To parse this JSON data, do
//
//     final inquiryProductModel = inquiryProductModelFromJson(jsonString);

import 'dart:convert';

InquiryProductModel inquiryProductModelFromJson(String str) =>
    InquiryProductModel.fromJson(json.decode(str));

String inquiryProductModelToJson(InquiryProductModel data) =>
    json.encode(data.toJson());

class InquiryProductModel {
  int? id;
  int? inquiryId;
  int? productId;
  int? quentity;
  int? isSynced = 0;

  InquiryProductModel({
    this.id,
    this.inquiryId,
    this.productId,
    this.quentity,
    this.isSynced,
  });

  factory InquiryProductModel.fromJson(Map<String, dynamic> json) =>
      InquiryProductModel(
        id: json["id"],
        inquiryId: json["inquiryId"],
        productId: json["productId"],
        quentity: json["quentity"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiryId": inquiryId,
    "productId": productId,
    "quentity": quentity,
    "isSynced": isSynced,
  };
}

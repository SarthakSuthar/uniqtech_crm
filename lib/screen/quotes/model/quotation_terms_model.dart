// To parse this JSON data, do
//
//     final quotationTermsModel = quotationTermsModelFromJson(jsonString);

import 'dart:convert';

QuotationTermsModel quotationTermsModelFromJson(String str) =>
    QuotationTermsModel.fromJson(json.decode(str));

String quotationTermsModelToJson(QuotationTermsModel data) =>
    json.encode(data.toJson());

class QuotationTermsModel {
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  int? quotationId;
  int? termId;
  int? isSynced = 0;

  QuotationTermsModel({
    this.id,
    this.quotationId,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.termId,
    this.isSynced,
  });

  factory QuotationTermsModel.fromJson(Map<String, dynamic> json) =>
      QuotationTermsModel(
        id: json["id"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedBy: json["updatedBy"],
        updatedAt: json["updatedAt"],
        quotationId: json["quotationId"],
        termId: json["termId"],
        isSynced: json["isSynced"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "updatedBy": updatedBy,
    "updatedAt": updatedAt,
    "quotationId": quotationId,
    "termId": termId,
    "isSynced": isSynced ?? 0,
  };
}

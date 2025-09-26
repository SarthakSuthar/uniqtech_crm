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
  int? quotationId;
  int? termId;
  int? isSynced = 0;

  QuotationTermsModel({this.id, this.quotationId, this.termId, this.isSynced});

  factory QuotationTermsModel.fromJson(Map<String, dynamic> json) =>
      QuotationTermsModel(
        id: json["id"],
        quotationId: json["quotationId"],
        termId: json["termId"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quotationId": quotationId,
    "termId": termId,
    "isSynced": isSynced,
  };
}

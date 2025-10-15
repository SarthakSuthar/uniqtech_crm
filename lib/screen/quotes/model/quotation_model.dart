// To parse this JSON data, do
//
//     final quotationModel = quotationModelFromJson(jsonString);

import 'dart:convert';

QuotationModel quotationModelFromJson(String str) =>
    QuotationModel.fromJson(json.decode(str));

String quotationModelToJson(QuotationModel data) => json.encode(data.toJson());

class QuotationModel {
  int? id;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  int? custId;
  String? custName1;
  String? custName2;
  String? date;
  String? email;
  String? mobileNo;
  String? source;
  String? subject;
  int? isSynced = 0;

  QuotationModel({
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.custId,
    this.custName1,
    this.custName2,
    this.date,
    this.email,
    this.mobileNo,
    this.source,
    this.subject,
    this.isSynced = 0,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
    id: json["id"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"],
    updatedBy: json["updatedBy"],
    updatedAt: json["updatedAt"],
    custId: json["custId"],
    custName1: json["cust_name1"],
    custName2: json["cust_name2"],
    date: json["date"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    source: json["source"],
    subject: json["subject"],
    isSynced: json["isSynced"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "updatedBy": updatedBy,
    "updatedAt": updatedAt,
    "custId": custId,
    "cust_name1": custName1,
    "cust_name2": custName2,
    "date": date,
    "email": email,
    "mobile_no": mobileNo,
    "source": source,
    "subject": subject,
    "isSynced": isSynced ?? 0,
  };
}

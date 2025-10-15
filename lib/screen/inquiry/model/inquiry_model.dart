// To parse this JSON data, do
//
//     final inquiryModel = inquiryModelFromJson(jsonString);

import 'dart:convert';

InquiryModel inquiryModelFromJson(String str) =>
    InquiryModel.fromJson(json.decode(str));

String inquiryModelToJson(InquiryModel data) => json.encode(data.toJson());

class InquiryModel {
  int? id;
  String? createdBy;
  String? updatedBy;
  int? custId;
  String? custName1;
  String? custName2;
  String? date;
  String? email;
  String? mobileNo;
  String? source;
  String? createdAt;
  String? updatedAt;
  int? isSynced = 0;

  InquiryModel({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.custId,
    this.custName1,
    this.custName2,
    this.date,
    this.email,
    this.mobileNo,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.isSynced = 0,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
    id: json["id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    custId: json["custId"],
    custName1: json["cust_name1"],
    custName2: json["cust_name2"],
    date: json["date"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    source: json["source"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isSynced: json["isSynced"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "custId": custId,
    "cust_name1": custName1,
    "cust_name2": custName2,
    "date": date,
    "email": email,
    "mobile_no": mobileNo,
    "source": source,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "isSynced": isSynced ?? 0,
  };
}

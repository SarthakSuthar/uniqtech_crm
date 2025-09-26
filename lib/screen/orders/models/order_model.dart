// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  int? id;
  String? uid;
  int? custId;
  String? custName1;
  String? custName2;
  String? date;
  String? email;
  String? mobileNo;
  String? source;
  int? isSynced = 0;

  OrderModel({
    this.id,
    this.uid,
    this.custId,
    this.custName1,
    this.custName2,
    this.date,
    this.email,
    this.mobileNo,
    this.source,
    this.isSynced,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    uid: json["uid"],
    custId: json["custId"],
    custName1: json["cust_name1"],
    custName2: json["cust_name2"],
    date: json["date"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    source: json["source"],
    isSynced: json["isSynced"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "custId": custId,
    "cust_name1": custName1,
    "cust_name2": custName2,
    "date": date,
    "email": email,
    "mobile_no": mobileNo,
    "source": source,
    "isSynced": isSynced,
  };
}

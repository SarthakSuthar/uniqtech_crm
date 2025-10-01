// To parse this JSON data, do
//
//     final uomModel = uomModelFromJson(jsonString);

import 'dart:convert';

UomModel uomModelFromJson(String str) => UomModel.fromJson(json.decode(str));

String uomModelToJson(UomModel data) => json.encode(data.toJson());

class UomModel {
  int? id;
  String? name;
  String? code;
  int? isSynced = 0;

  UomModel({this.id, this.name, this.code, this.isSynced = 0});

  factory UomModel.fromJson(Map<String, dynamic> json) => UomModel(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    isSynced: json["isSynced"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "isSynced": isSynced,
  };
}

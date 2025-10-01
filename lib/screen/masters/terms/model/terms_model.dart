// To parse this JSON data, do
//
//     final termsModel = termsModelFromJson(jsonString);

import 'dart:convert';

TermsModel termsModelFromJson(String str) =>
    TermsModel.fromJson(json.decode(str));

String termsModelToJson(TermsModel data) => json.encode(data.toJson());

class TermsModel {
  int? id;
  String? title;
  String? description;
  int? isSynced = 0;

  TermsModel({this.id, this.title, this.description, this.isSynced});

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    isSynced: json["isSynced"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "isSynced": isSynced,
  };
}

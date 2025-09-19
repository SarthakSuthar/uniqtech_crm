// To parse this JSON data, do
//
//     final quotationFollowupModel = quotationFollowupModelFromJson(jsonString);

import 'dart:convert';

QuotationFollowupModel quotationFollowupModelFromJson(String str) =>
    QuotationFollowupModel.fromJson(json.decode(str));

String quotationFollowupModelToJson(QuotationFollowupModel data) =>
    json.encode(data.toJson());

class QuotationFollowupModel {
  int? id;
  int? quotationId;
  String? followupDate;
  String? followupStatus;
  String? followupRemarks;
  String? followupAssignedTo;
  int? isSynced;

  QuotationFollowupModel({
    this.id,
    this.quotationId,
    this.followupDate,
    this.followupStatus,
    this.followupRemarks,
    this.followupAssignedTo,
    this.isSynced,
  });

  factory QuotationFollowupModel.fromJson(Map<String, dynamic> json) =>
      QuotationFollowupModel(
        id: json["id"],
        quotationId: json["quotationId"],
        followupDate: json["followupDate"],
        followupStatus: json["followupStatus"],
        followupRemarks: json["followupRemarks"],
        followupAssignedTo: json["followupAssignedTo"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quotationId": quotationId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced,
  };
}

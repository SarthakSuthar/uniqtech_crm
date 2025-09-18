// To parse this JSON data, do
//
//     final inquiryFollowupModel = inquiryFollowupModelFromJson(jsonString);

import 'dart:convert';

InquiryFollowupModel inquiryFollowupModelFromJson(String str) =>
    InquiryFollowupModel.fromJson(json.decode(str));

String inquiryFollowupModelToJson(InquiryFollowupModel data) =>
    json.encode(data.toJson());

class InquiryFollowupModel {
  int? id;
  int? inquiryId;
  String? followupDate;
  String? followupStatus;
  String? followupRemarks;
  String? followupAssignedTo;
  int? isSynced;

  InquiryFollowupModel({
    this.id,
    this.inquiryId,
    this.followupDate,
    this.followupStatus,
    this.followupRemarks,
    this.followupAssignedTo,
    this.isSynced,
  });

  factory InquiryFollowupModel.fromJson(Map<String, dynamic> json) =>
      InquiryFollowupModel(
        id: json["id"],
        inquiryId: json["inquiryId"],
        followupDate: json["followupDate"],
        followupStatus: json["followupStatus"],
        followupRemarks: json["followupRemarks"],
        followupAssignedTo: json["followupAssignedTo"],
        isSynced: json["isSynced"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiryId": inquiryId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced,
  };
}

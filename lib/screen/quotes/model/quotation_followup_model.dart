class QuotationFollowupModel {
  int? id;
  int? quotationId;
  String? followupDate;
  String? followupStatus;
  String? followupType;
  String? followupRemarks;
  String? followupAssignedTo;
  int? isSynced = 0;

  QuotationFollowupModel({
    this.id,
    this.quotationId,
    this.followupDate,
    this.followupStatus,
    this.followupType,
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
        followupType: json["followupType"],
        followupRemarks: json["followupRemarks"],
        followupAssignedTo: json["followupAssignedTo"],
        isSynced: json["isSynced"] ?? 0,
      );

  /// For INSERT (id included only if not null)
  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "quotationId": quotationId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupType": followupType,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced ?? 0,
  };

  /// For UPDATE (exclude id, update only fields)
  Map<String, dynamic> toUpdateJson() => {
    "quotationId": quotationId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupType": followupType,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced ?? 0,
  };
}

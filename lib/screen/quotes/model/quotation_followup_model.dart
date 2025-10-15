class QuotationFollowupModel {
  int? id;
  int? quotationId;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  String? followupDate;
  String? followupStatus;
  String? followupType;
  String? followupRemarks;
  String? followupAssignedTo;
  int? isSynced;

  QuotationFollowupModel({
    this.id,
    this.quotationId,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.followupDate,
    this.followupStatus,
    this.followupType,
    this.followupRemarks,
    this.followupAssignedTo,
    this.isSynced = 0,
  });

  factory QuotationFollowupModel.fromJson(Map<String, dynamic> json) =>
      QuotationFollowupModel(
        id: json["id"],
        quotationId: json["quotationId"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedBy: json["updatedBy"],
        updatedAt: json["updatedAt"],
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
    "createdBy": createdBy,
    "createdAt": createdAt,
    "updatedBy": updatedBy,
    "updatedAt": updatedAt,
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
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_by": updatedBy,
    "updated_at": updatedAt,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupType": followupType,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced ?? 0,
  };
}

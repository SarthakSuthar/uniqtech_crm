class OrderFollowupModel {
  int? id;
  int? orderId;
  String? followupDate;
  String? followupStatus;
  String? followupType;
  String? followupRemarks;
  String? followupAssignedTo;
  int? isSynced;

  OrderFollowupModel({
    this.id,
    this.orderId,
    this.followupDate,
    this.followupStatus,
    this.followupType,
    this.followupRemarks,
    this.followupAssignedTo,
    this.isSynced = 0,
  });

  factory OrderFollowupModel.fromJson(Map<String, dynamic> json) =>
      OrderFollowupModel(
        id: json["id"],
        orderId: json["orderId"],
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
    "orderId": orderId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupType": followupType,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced ?? 0,
  };

  /// For UPDATE (exclude id, update only fields)
  Map<String, dynamic> toUpdateJson() => {
    "orderId": orderId,
    "followupDate": followupDate,
    "followupStatus": followupStatus,
    "followupType": followupType,
    "followupRemarks": followupRemarks,
    "followupAssignedTo": followupAssignedTo,
    "isSynced": isSynced ?? 0,
  };
}

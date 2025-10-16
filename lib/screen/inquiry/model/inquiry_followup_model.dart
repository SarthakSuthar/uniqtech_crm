class InquiryFollowupModel {
  final int? id;
  final int inquiryId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String followupDate;
  final String? followupStatus;
  final String? followupType;
  final String? followupRemarks;
  final String? followupAssignedTo;
  final int isSynced;

  InquiryFollowupModel({
    this.id,
    required this.inquiryId,
    required this.followupDate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.followupStatus,
    this.followupType,
    this.followupRemarks,
    this.followupAssignedTo,
    this.isSynced = 0,
  });

  factory InquiryFollowupModel.fromJson(Map<String, dynamic> json) {
    return InquiryFollowupModel(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      inquiryId: json['inquiryId'],
      followupDate: json['followupDate'],
      followupStatus: json['followupStatus'],
      followupType: json['followupType'],
      followupRemarks: json['followupRemarks'],
      followupAssignedTo: json['followupAssignedTo'],
      isSynced: json['isSynced'] ?? 0,
    );
  }

  // For insert
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // only include if not null
      'inquiryId': inquiryId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'followupDate': followupDate,
      'followupStatus': followupStatus,
      'followupType': followupType,
      'followupRemarks': followupRemarks,
      'followupAssignedTo': followupAssignedTo,
      'isSynced': isSynced,
    };
  }

  // For update (exclude id)
  Map<String, dynamic> toUpdateJson() {
    return {
      'inquiryId': inquiryId,
      'updated_by': updatedBy,
      'updated_at': updatedAt,
      'followupDate': followupDate,
      'followupStatus': followupStatus,
      'followupType': followupType,
      'followupRemarks': followupRemarks,
      'followupAssignedTo': followupAssignedTo,
      'isSynced': isSynced,
    };
  }
}

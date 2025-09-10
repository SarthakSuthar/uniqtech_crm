class ContactModel {
  int? id; // local auto-increment id (SQLite only)
  String? uid; // Firebase UID or custom contact id
  String? custName;
  String? address;
  String? city;
  String? state;
  String? district;
  String? country;
  String? pincode;
  String? mobileNo;
  String? email;
  String? website;
  String? businessType;
  String? industryType;
  String? status;
  String? contactName;
  String? department;
  String? designation;
  String? contEmail;
  String? contMobileNo;
  String? contPhoneNo;
  int? isSynced;

  ContactModel({
    this.id,
    this.uid,
    this.custName,
    this.address,
    this.city,
    this.state,
    this.district,
    this.country,
    this.pincode,
    this.mobileNo,
    this.email,
    this.website,
    this.businessType,
    this.industryType,
    this.status,
    this.contactName,
    this.department,
    this.designation,
    this.contEmail,
    this.contMobileNo,
    this.contPhoneNo,
    this.isSynced = 0,
  });

  /// Convert a ContactModel into a Map (for SQLite insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'cust_name': custName,
      'address': address,
      'city': city,
      'state': state,
      'district': district,
      'country': country,
      'pincode': pincode,
      'mobile_no': mobileNo,
      'email': email,
      'website': website,
      'business_type': businessType,
      'industry_type': industryType,
      'status': status,
      'contact_name': contactName,
      'department': department,
      'designation': designation,
      'cont_email': contEmail,
      'cont_mobile_no': contMobileNo,
      'cont_phone_no': contPhoneNo,
      'isSynced': isSynced,
    };
  }

  /// Create a ContactModel from a Map (retrieved from SQLite)
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      uid: map['uid'],
      custName: map['cust_name'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      district: map['district'],
      country: map['country'],
      pincode: map['pincode'],
      mobileNo: map['mobile_no'],
      email: map['email'],
      website: map['website'],
      businessType: map['business_type'],
      industryType: map['industry_type'],
      status: map['status'],
      contactName: map['contact_name'],
      department: map['department'],
      designation: map['designation'],
      contEmail: map['cont_email'],
      contMobileNo: map['cont_mobile_no'],
      contPhoneNo: map['cont_phone_no'],
      isSynced: map['isSynced'],
    );
  }

  /// Convert to JSON (for Firebase upload)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'cust_name': custName,
      'address': address,
      'city': city,
      'state': state,
      'district': district,
      'country': country,
      'pincode': pincode,
      'mobile_no': mobileNo,
      'email': email,
      'website': website,
      'business_type': businessType,
      'industry_type': industryType,
      'status': status,
      'contact_name': contactName,
      'department': department,
      'designation': designation,
      'cont_email': contEmail,
      'cont_mobile_no': contMobileNo,
      'cont_phone_no': contPhoneNo,
    };
  }

  /// Create a ContactModel from JSON (from Firebase)
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      uid: json['uid'],
      custName: json['cust_name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      district: json['district'],
      country: json['country'],
      pincode: json['pincode'],
      mobileNo: json['mobile_no'],
      email: json['email'],
      website: json['website'],
      businessType: json['business_type'],
      industryType: json['industry_type'],
      status: json['status'],
      contactName: json['contact_name'],
      department: json['department'],
      designation: json['designation'],
      contEmail: json['cont_email'],
      contMobileNo: json['cont_mobile_no'],
      contPhoneNo: json['cont_phone_no'],
    );
  }
}

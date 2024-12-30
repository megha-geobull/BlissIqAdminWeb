class AllSchoolModel {
  int? status;
  String? message;
  List<Data>? data;

  AllSchoolModel({
    this.status,
    this.message,
    this.data,
  });

  AllSchoolModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? id;
  final String? schoolName;
  final String? principalEmail;
  final int? principalPhone;
  final String? token;
  final String? schoolRegNumber;
   String? status;
  final String? schoolType;
  final String? address;
  final String? principalName;
  final String? affiliatedCompany;
  final String? companyId;
  final String? approvalStatus;

  Data({
    this.id,
    this.schoolName,
    this.principalEmail,
    this.principalPhone,
    this.token,
    this.schoolRegNumber,
    this.status,
    this.schoolType,
    this.address,
    this.principalName,
    this.affiliatedCompany,
    this.companyId,
    this.approvalStatus,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        schoolName = json['schoolName'] as String?,
        principalEmail = json['principalEmail'] as String?,
        principalPhone = json['principalPhone'] as int?,
        token = json['token'] as String?,
        schoolRegNumber = json['schoolRegNumber'] as String?,
        status = json['status'] as String?,
        schoolType = json['schoolType'] as String?,
        address = json['address'] as String?,
        principalName = json['principalName'] as String?,
        affiliatedCompany = json['affiliatedCompany'] as String?,
        companyId = json['company_id'] as String?,
        approvalStatus = json['approval_status'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'schoolName' : schoolName,
    'principalEmail' : principalEmail,
    'principalPhone' : principalPhone,
    'token' : token,
    'schoolRegNumber' : schoolRegNumber,
    'status' : status,
    'schoolType' : schoolType,
    'address' : address,
    'principalName' : principalName,
    'affiliatedCompany' : affiliatedCompany,
    'company_id' : companyId,
    'approval_status' : approvalStatus
  };
}
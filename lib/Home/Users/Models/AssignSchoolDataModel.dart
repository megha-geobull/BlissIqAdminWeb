class AssignSchoolDataModel {
  final int? status;
  final List<GetAssignSchoolData>? data;

  AssignSchoolDataModel({
    this.status,
    this.data,
  });

  AssignSchoolDataModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as List?)?.map((dynamic e) => GetAssignSchoolData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class GetAssignSchoolData {
  final String? id;
  final String? schoolName;
  final String? principalEmail;
  final int? principalPhone;
  final String? token;
  final String? schoolRegNumber;
  final String? status;
  final String? schoolType;
  final String? address;
  final String? principalName;
  final String? affiliatedCompany;
  final String? companyId;
  final String? approvalStatus;

  GetAssignSchoolData({
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

  GetAssignSchoolData.fromJson(Map<String, dynamic> json)
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
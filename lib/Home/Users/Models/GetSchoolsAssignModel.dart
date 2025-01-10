
class GetSchoolsAssignModel {
  GetSchoolsAssignModel({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<AllAssignedSchoolsData> data;

  GetSchoolsAssignModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>AllAssignedSchoolsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllAssignedSchoolsData {
  AllAssignedSchoolsData({
    required this.id,
    required this.schoolName,
    required this.principalEmail,
    required this.principalPhone,
    required this.token,
    required this.schoolRegNumber,
    required this.status,
    required this.schoolType,
    required this.address,
    required this.principalName,
    required this.affiliatedCompany,
    required this.companyId,
    required this.approvalStatus,
  });
  late final String id;
  late final String schoolName;
  late final String principalEmail;
  late final int principalPhone;
  late final String token;
  late final String schoolRegNumber;
  late final String status;
  late final String schoolType;
  late final String address;
  late final String principalName;
  late final String affiliatedCompany;
  late final String companyId;
  late final String approvalStatus;

  AllAssignedSchoolsData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    schoolName = json['schoolName'];
    principalEmail = json['principalEmail'];
    principalPhone = json['principalPhone'];
    token = json['token'];
    schoolRegNumber = json['schoolRegNumber'];
    status = json['status'];
    schoolType = json['schoolType'];
    address = json['address'];
    principalName = json['principalName'];
    affiliatedCompany = json['affiliatedCompany'];
    companyId = json['company_id'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['schoolName'] = schoolName;
    _data['principalEmail'] = principalEmail;
    _data['principalPhone'] = principalPhone;
    _data['token'] = token;
    _data['schoolRegNumber'] = schoolRegNumber;
    _data['status'] = status;
    _data['schoolType'] = schoolType;
    _data['address'] = address;
    _data['principalName'] = principalName;
    _data['affiliatedCompany'] = affiliatedCompany;
    _data['company_id'] = companyId;
    _data['approval_status'] = approvalStatus;
    return _data;
  }
}
class GetSchoolsAssignModel {
  GetSchoolsAssignModel({
    required this.status,
    required this.data,
  });

  late final int status;
  late final List<AllAssignedSchoolsData> data;

  GetSchoolsAssignModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 0;
    data = (json['data'] as List)
        .map((e) => AllAssignedSchoolsData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AllAssignedSchoolsData {
  AllAssignedSchoolsData({
    required this.id,
    required this.schoolName,
    required this.principalEmail,
    this.principalPhone, // Made nullable
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
  late final int? principalPhone; // Changed to nullable int?
  late final String token;
  late final String schoolRegNumber;
  late final String status;
  late final String schoolType;
  late final String address;
  late final String principalName;
  late final String affiliatedCompany;
  late final String companyId;
  late final String approvalStatus;

  AllAssignedSchoolsData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    schoolName = json['schoolName'] ?? '';
    principalEmail = json['principalEmail'] ?? '';
    principalPhone = json['principalPhone'] != null
        ? int.tryParse(json['principalPhone'].toString())
        : null; // Handles null or invalid int values
    token = json['token'] ?? '';
    schoolRegNumber = json['schoolRegNumber'] ?? '';
    status = json['status'] ?? '';
    schoolType = json['schoolType'] ?? '';
    address = json['address'] ?? '';
    principalName = json['principalName'] ?? '';
    affiliatedCompany = json['affiliatedCompany'] ?? '';
    companyId = json['company_id'] ?? '';
    approvalStatus = json['approval_status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'schoolName': schoolName,
      'principalEmail': principalEmail,
      'principalPhone': principalPhone,
      'token': token,
      'schoolRegNumber': schoolRegNumber,
      'status': status,
      'schoolType': schoolType,
      'address': address,
      'principalName': principalName,
      'affiliatedCompany': affiliatedCompany,
      'company_id': companyId,
      'approval_status': approvalStatus,
    };
  }
}

class GetAllCompanyModel {
  final int? status;
  final String? message;
  final List<Data>? data;

  GetAllCompanyModel({
    this.status,
    this.message,
    this.data,
  });

  GetAllCompanyModel.fromJson(Map<String, dynamic> json)
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
  final String? ownerName;
  final String? companyName;
  final String? contactNo;
  final String? email;
  final String? profilePic;
  final dynamic panCard;
  final String? cinNumber;
  final String? gstNumber;
  final String? approvalStatus;
  final String? token;

  Data({
    this.id,
    this.ownerName,
    this.companyName,
    this.contactNo,
    this.email,
    this.profilePic,
    this.panCard,
    this.cinNumber,
    this.gstNumber,
    this.approvalStatus,
    this.token,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        ownerName = json['owner_name'] as String?,
        companyName = json['company_name'] as String?,
        contactNo = json['contact_no'] as String?,
        email = json['email'] as String?,
        profilePic = json['profile_pic'] as String?,
        panCard = json['pan_card'],
        cinNumber = json['cin_number'] as String?,
        gstNumber = json['gst_number'] as String?,
        approvalStatus = json['approval_status'] as String?,
        token = json['token'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'owner_name' : ownerName,
    'company_name' : companyName,
    'contact_no' : contactNo,
    'email' : email,
    'profile_pic' : profilePic,
    'pan_card' : panCard,
    'cin_number' : cinNumber,
    'gst_number' : gstNumber,
    'approval_status' : approvalStatus,
    'token' : token
  };
}
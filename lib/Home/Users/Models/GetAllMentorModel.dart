class GetAllMentorModel {
  int? status;
  String? message;
  List<Data>? data;

  GetAllMentorModel({this.status, this.message, this.data});

  GetAllMentorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? fullName;
  String? email;
  String? profileImage;
  String? token;
  int? contactNo;
  String? status;
  String? userType;
  String? address;
  String? experience;
  String? qualification;
  String? introBio;
  String? approvalStatus;
  String? schoolId;

  Data(
      {this.sId,
        this.fullName,
        this.email,
        this.profileImage,
        this.token,
        this.contactNo,
        this.status,
        this.userType,
        this.address,
        this.experience,
        this.qualification,
        this.introBio,
        this.approvalStatus,
        this.schoolId});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    profileImage = json['profile_image'];
    token = json['token'];
    contactNo = json['contact_no'];
    status = json['status'];
    userType = json['userType'];
    address = json['address'];
    experience = json['experience'];
    qualification = json['qualification'];
    introBio = json['introBio'];
    approvalStatus = json['approval_status'];
    schoolId = json['school_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['token'] = this.token;
    data['contact_no'] = this.contactNo;
    data['status'] = this.status;
    data['userType'] = this.userType;
    data['address'] = this.address;
    data['experience'] = this.experience;
    data['qualification'] = this.qualification;
    data['introBio'] = this.introBio;
    data['approval_status'] = this.approvalStatus;
    data['school_id'] = this.schoolId;
    return data;
  }
}
class GetMentorsAssignModel {
  GetMentorsAssignModel({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<AllAssignedMentorsData> data;

  GetMentorsAssignModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>AllAssignedMentorsData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllAssignedMentorsData {
  AllAssignedMentorsData({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.token,
    required this.contactNo,
    required this.status,
    required this.userType,
    required this.address,
    required this.experience,
    required this.qualification,
    required this.introBio,
    required this.approvalStatus,
    required this.schoolId,
  });
  late final String id;
  late final String fullName;
  late final String email;
  late final Null profileImage;
  late final String token;
  late final int contactNo;
  late final String status;
  late final String userType;
  late final String address;
  late final String experience;
  late final String qualification;
  late final String introBio;
  late final String approvalStatus;
  late final String schoolId;

  AllAssignedMentorsData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    profileImage = null;
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
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['fullName'] = fullName;
    _data['email'] = email;
    _data['profile_image'] = profileImage;
    _data['token'] = token;
    _data['contact_no'] = contactNo;
    _data['status'] = status;
    _data['userType'] = userType;
    _data['address'] = address;
    _data['experience'] = experience;
    _data['qualification'] = qualification;
    _data['introBio'] = introBio;
    _data['approval_status'] = approvalStatus;
    _data['school_id'] = schoolId;
    return _data;
  }
}
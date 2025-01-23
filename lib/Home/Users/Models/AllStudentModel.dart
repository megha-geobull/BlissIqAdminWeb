class AllStudentModel {
  AllStudentModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<Data> data;

  AllStudentModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userName,
    required this.email,
    required this.profileImage,
    required this.token,
    required this.contactNo,
    required this.status,
    required this.mentorId,
    required this.schoolId,
    required this.school,
    required this.stdClass,
    required this.language,
    required this.ageGroup,
    required this.purpose,
    required this.score,
    required this.rank,
    required this.boardName,
  });
  late final String id;
  late final String userName;
  late final String email;
  late final String profileImage;
  late final String token;
  late final String contactNo;
  late final String status;
  late final String mentorId;
  late final String schoolId;
  late final String school;
  late final String stdClass;
  late final String language;
  late final String ageGroup;
  late final String purpose;
  late final String score;
  late final String rank;
  late final String? boardName;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userName = json['user_name']??"";
    email = json['email']??"";
    profileImage = json['profile_image'].toString()!="null"?json['profile_image']:'';
    token = json['token']??"";
    contactNo = json['contact_no'].toString()??"";
    status = json['status']??'';
    mentorId = json['mentor_id']??"";
    schoolId = json['school_id']??'';
    school = json['school']??"";
    stdClass = json['std_class']??"";
    language = json['language']??"";
    ageGroup = json['age_group']??"";
    purpose = json['purpose']??'';
    score = json['score'].toString()??"";
    rank = json['rank'].toString()??'';
    boardName = json['board_name']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_name'] = userName;
    _data['email'] = email;
    _data['profile_image'] = profileImage;
    _data['token'] = token;
    _data['contact_no'] = contactNo;
    _data['status'] = status;
    _data['mentor_id'] = mentorId;
    _data['school_id'] = schoolId;
    _data['school'] = school;
    _data['std_class'] = stdClass;
    _data['language'] = language;
    _data['age_group'] = ageGroup;
    _data['purpose'] = purpose;
    _data['score'] = score;
    _data['rank'] = rank;
    _data['board_name'] = boardName;
    return _data;
  }
}
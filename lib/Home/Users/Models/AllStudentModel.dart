class AllStudentModel {
  int? status;
  String? message;
  List<Data>? data;

  AllStudentModel({this.status, this.message, this.data});

  AllStudentModel.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  String? email;
  String? profileImage;
  String? token;
  int? contactNo;
  String? status;
  String? mentorId;
  Null? schoolId;
  String? school;
  String? stdClass;
  String? language;
  String? ageGroup;
  String? purpose;
  String? score;
  String? rank;
  String? boardName;

  Data(
      {this.sId,
        this.userName,
        this.email,
        this.profileImage,
        this.token,
        this.contactNo,
        this.status,
        this.mentorId,
        this.schoolId,
        this.school,
        this.stdClass,
        this.language,
        this.ageGroup,
        this.purpose,
        this.score,
        this.rank,
        this.boardName});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    token = json['token'];
    contactNo = json['contact_no'];
    status = json['status'];
    mentorId = json['mentor_id'];
    schoolId = json['school_id'];
    school = json['school'];
    stdClass = json['std_class'];
    language = json['language'];
    ageGroup = json['age_group'];
    purpose = json['purpose'];
    score = json['score'];
    rank = json['rank'];
    boardName = json['board_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['token'] = this.token;
    data['contact_no'] = this.contactNo;
    data['status'] = this.status;
    data['mentor_id'] = this.mentorId;
    data['school_id'] = this.schoolId;
    data['school'] = this.school;
    data['std_class'] = this.stdClass;
    data['language'] = this.language;
    data['age_group'] = this.ageGroup;
    data['purpose'] = this.purpose;
    data['score'] = this.score;
    data['rank'] = this.rank;
    data['board_name'] = this.boardName;
    return data;
  }
}
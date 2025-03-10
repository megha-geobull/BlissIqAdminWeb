// class UserLeaderBoardModel {
//   UserLeaderBoardModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//   late final int status;
//   late final String message;
//   late final List<Data> data;
//
//   UserLeaderBoardModel.fromJson(Map<String, dynamic> json){
//     status = json['status'];
//     message = json['message'];
//     data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }
//
// class Data {
//   Data({
//     required this.id,
//     required this.userName,
//     required this.email,
//     required this.profileImage,
//     required this.token,
//     required this.contactNo,
//     required this.status,
//     required this.mentorId,
//     this.schoolId,
//     this.companyId,
//     required this.school,
//     required this.stdClass,
//     required this.language,
//     required this.ageGroup,
//     required this.purpose,
//     required this.score,
//     required this.rank,
//     required this.boardName,
//     this.subject,
//     this.latitude,
//     this.longitude,
//     this.address,
//     this.registrationDate,
//   });
//   late final String id;
//   late final String userName;
//   late final String email;
//   late final String profileImage;
//   late final String token;
//   late final int contactNo;
//   late final String status;
//   late final String mentorId;
//   late final String? schoolId;
//   late final String? companyId;
//   late final String school;
//   late final String stdClass;
//   late final String language;
//   late final String ageGroup;
//   late final String purpose;
//   late final int score;
//   late final int rank;
//   late final String boardName;
//   late final String? subject;
//   late final String? latitude;
//   late final String? longitude;
//   late final String? address;
//   late final String? registrationDate;
//
//   Data.fromJson(Map<String, dynamic> json){
//     id = json['_id'];
//     userName = json['user_name'];
//     email = json['email'];
//     profileImage = json['profile_image'];
//     token = json['token'];
//     contactNo = json['contact_no'];
//     status = json['status'];
//     mentorId = json['mentor_id'];
//     schoolId = null;
//     companyId = null;
//     school = json['school'];
//     stdClass = json['std_class'];
//     language = json['language'];
//     ageGroup = json['age_group'];
//     purpose = json['purpose'];
//     score = json['score'];
//     rank = json['rank'];
//     boardName = json['board_name'];
//     subject = null;
//     latitude = null;
//     longitude = null;
//     address = null;
//     registrationDate = null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['_id'] = id;
//     _data['user_name'] = userName;
//     _data['email'] = email;
//     _data['profile_image'] = profileImage;
//     _data['token'] = token;
//     _data['contact_no'] = contactNo;
//     _data['status'] = status;
//     _data['mentor_id'] = mentorId;
//     _data['school_id'] = schoolId;
//     _data['company_id'] = companyId;
//     _data['school'] = school;
//     _data['std_class'] = stdClass;
//     _data['language'] = language;
//     _data['age_group'] = ageGroup;
//     _data['purpose'] = purpose;
//     _data['score'] = score;
//     _data['rank'] = rank;
//     _data['board_name'] = boardName;
//     _data['subject'] = subject;
//     _data['latitude'] = latitude;
//     _data['longitude'] = longitude;
//     _data['address'] = address;
//     _data['registration_date'] = registrationDate;
//     return _data;
//   }
// }
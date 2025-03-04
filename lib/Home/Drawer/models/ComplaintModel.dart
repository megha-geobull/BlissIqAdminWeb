import 'package:flutter/material.dart';

class ComplaintModel {
  final int? status;
  final String? msg;
  final List<ComplaintData>? data;

  ComplaintModel({this.status, this.msg, this.data});

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      status: json['status'] as int?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => ComplaintData.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class ComplaintData {
  final String? id;
  final String? userId;
  final String? mentorId;
  final String? schoolId;
  final String? userName;
  final String? email;
  final String? issue;
  final String? attachment;
  final String? status;
  final MentorDetails? mentorDetails;

  ComplaintData({
    this.id,
    this.userId,
    this.mentorId,
    this.schoolId,
    this.userName,
    this.email,
    this.issue,
    this.attachment,
    this.status,
    this.mentorDetails,
  });

  factory ComplaintData.fromJson(Map<String, dynamic> json) {
    return ComplaintData(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      mentorId: json['mentor_id'] as String?,
      schoolId: json['school_id'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      issue: json['issue'] as String?,
      attachment: json['attachment'] as String?,
      status: json['status'] as String?,
      mentorDetails: json['mentor_details'] != null
          ? MentorDetails.fromJson(json['mentor_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'mentor_id': mentorId,
      'school_id': schoolId,
      'user_name': userName,
      'email': email,
      'issue': issue,
      'attachment': attachment,
      'status': status,
      'mentor_details': mentorDetails?.toJson(),
    };
  }
}

class MentorDetails {
  final String? fullName;
  final String? email;
  final int? contactNo;

  MentorDetails({this.fullName, this.email, this.contactNo});

  factory MentorDetails.fromJson(Map<String, dynamic> json) {
    return MentorDetails(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      contactNo: json['contact_no'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'contact_no': contactNo,
    };
  }
}

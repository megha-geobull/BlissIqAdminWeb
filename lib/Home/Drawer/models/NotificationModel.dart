class NotificationModel {
  final int? status;
  final String? message;
  final List<NotificationData>? data;

  NotificationModel({this.status, this.message, this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => NotificationData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class NotificationData {
  final String? id;
  final String? userId;
  final String? title;
  final String? descriptions;

  NotificationData({this.id, this.userId, this.title, this.descriptions});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String?,
      descriptions: json['descriptions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'title': title,
      'descriptions': descriptions,
    };
  }
}

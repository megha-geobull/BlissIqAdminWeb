class GetRearrangeModel {
  final int? status;
  final String? message;
  final List<ReArrange>? data;

  GetRearrangeModel({
    this.status,
    this.message,
    this.data,
  });

  GetRearrangeModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => ReArrange.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class ReArrange {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? subTopicId;
  final String? topicId;
  final String? questionType;
  final String? title;
  final String? question;
  final String? qImage;
  final String? answer;
  final int? points;
  final int? index;

  ReArrange({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.subTopicId,
    this.topicId,
    this.questionType,
    this.title,
    this.question,
    this.qImage,
    this.answer,
    this.points,
    this.index,
  });

  ReArrange.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        topicId = json['topic_id'] as String?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        question = json['question'] as String?,
        qImage = json['q_image'] as String?,
        answer = json['answer'] as String?,
        points = json['points'] as int?,
        index = json['index'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'sub_topic_id' : subTopicId,
    'topic_id' : topicId,
    'question_type' : questionType,
    'title' : title,
    'question' : question,
    'q_image' : qImage,
    'answer' : answer,
    'points' : points,
    'index' : index
  };
}
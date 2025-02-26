class ReArrangeSentence {
  final int? status;
  final String? message;
  final List<ReArrangeSentenceData>? data;

  ReArrangeSentence({
    this.status,
    this.message,
    this.data,
  });

  ReArrangeSentence.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => ReArrangeSentenceData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class ReArrangeSentenceData {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? topicId;
  final String? subTopicId;
  final String? questionType;
  final String? title;
  final String? question;
  final String? answer;
  final String? questionFormat;
  final int? points;
  final int? index;

  ReArrangeSentenceData({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.topicId,
    this.subTopicId,
    this.questionType,
    this.title,
    this.question,
    this.answer,
    this.questionFormat,
    this.points,
    this.index,
  });

  ReArrangeSentenceData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        topicId = json['topic_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        question = json['question'] as String?,
        answer = json['answer'] as String?,
        questionFormat = json['question_format'] as String?,
        points = json['points'] as int?,
        index = json['index'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'topic_id' : topicId,
    'sub_topic_id' : subTopicId,
    'question_type' : questionType,
    'title' : title,
    'question' : question,
    'answer' : answer,
    'question_format' : questionFormat,
    'points' : points,
    'index' : index
  };
}
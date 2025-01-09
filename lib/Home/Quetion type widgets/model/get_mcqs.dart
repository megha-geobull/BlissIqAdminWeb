class GetMCQS {
  final int? status;
  final String? message;
  final List<Mcqs>? data;

  GetMCQS({
    this.status,
    this.message,
    this.data,
  });

  GetMCQS.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => Mcqs.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Mcqs {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? subTopicId;
  final String? topicId;
  final String? questionType;
  final String? title;
  final String? question;
  final dynamic qImage;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? answer;
  final int? points;
  final int? index;

  Mcqs({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.subTopicId,
    this.topicId,
    this.questionType,
    this.title,
    this.question,
    this.qImage,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.answer,
    this.points,
    this.index,
  });

  Mcqs.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        topicId = json['topic_id'] as String?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        question = json['question'] as String?,
        qImage = json['q_image'],
        optionA = json['option_a'] as String?,
        optionB = json['option_b'] as String?,
        optionC = json['option_c'] as String?,
        optionD = json['option_d'] as String?,
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
    'option_a' : optionA,
    'option_b' : optionB,
    'option_c' : optionC,
    'option_d' : optionD,
    'answer' : answer,
    'points' : points,
    'index' : index
  };
}
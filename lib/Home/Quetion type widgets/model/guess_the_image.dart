class GuessTheImage {
  final int? status;
  final String? message;
  final List<GuessTheImageData>? data;

  GuessTheImage({
    this.status,
    this.message,
    this.data,
  });

  GuessTheImage.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => GuessTheImageData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class GuessTheImageData {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? topicId;
  final String? subTopicId;
  final String? questionType;
  final String? title;
  final dynamic qImage;
  final String? qImageName;
  final String? answer;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final int? points;
  final int? index;

  GuessTheImageData({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.topicId,
    this.subTopicId,
    this.questionType,
    this.title,
    this.qImage,
    this.qImageName,
    this.answer,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.points,
    this.index,
  });

  GuessTheImageData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        topicId = json['topic_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        qImage = json['q_image'],
        qImageName = json['q_image_name'] as String?,
        answer = json['answer'] as String?,
        optionA = json['option_a'] as String?,
        optionB = json['option_b'] as String?,
        optionC = json['option_c'] as String?,
        optionD = json['option_d'] as String?,
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
    'q_image' : qImage,
    'q_image_name' : qImageName,
    'answer' : answer,
    'option_a' : optionA,
    'option_b' : optionB,
    'option_c' : optionC,
    'option_d' : optionD,
    'points' : points,
    'index' : index
  };
}
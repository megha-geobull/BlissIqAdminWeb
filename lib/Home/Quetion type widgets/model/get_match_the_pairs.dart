class GetMatchThePairs {
  final int? status;
  final String? detail;
  final List<MatchPairs>? data;

  GetMatchThePairs({
    this.status,
    this.detail,
    this.data,
  });

  GetMatchThePairs.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        detail = json['detail'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => MatchPairs.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'detail' : detail,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class MatchPairs {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? topicId;
  final String? subTopicId;
  final String? questionType;
  final String? title;
  final String? questionFormat;
  final String? answerFormat;
  final int? points;
  final int? index;
  final List<Entries>? entries;

  MatchPairs({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.topicId,
    this.subTopicId,
    this.questionType,
    this.title,
    this.questionFormat,
    this.answerFormat,
    this.points,
    this.index,
    this.entries,
  });

  MatchPairs.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        topicId = json['topic_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        questionFormat = json['question_format'] as String?,
        answerFormat = json['answer_format'] as String?,
        points = json['points'] as int?,
        index = json['index'] as int?,
        entries = (json['entries'] as List?)?.map((dynamic e) => Entries.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'topic_id' : topicId,
    'sub_topic_id' : subTopicId,
    'question_type' : questionType,
    'title' : title,
    'question_format' : questionFormat,
    'answer_format' : answerFormat,
    'points' : points,
    'index' : index,
    'entries' : entries?.map((e) => e.toJson()).toList()
  };
}

class Entries {
  final String? id;
  final String? question;
  final String? answer;
  final String? questionImgName;
  final String? answerImgName;
  final String? questionImg;
  final String? answerImg;

  Entries({
    this.id,
    this.question,
    this.answer,
    this.questionImgName,
    this.answerImgName,
    this.questionImg,
    this.answerImg,
  });

  Entries.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        question = json['question'] as String?,
        answer = json['answer'] as String?,
        questionImgName = json['question_img_name'] as String?,
        answerImgName = json['answer_img_name'] as String?,
        questionImg = json['question_img'] as String?,
        answerImg = json['answer_img'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'question' : question,
    'answer' : answer,
    'question_img_name' : questionImgName,
    'answer_img_name' : answerImgName,
    'question_img' : questionImg,
    'answer_img' : answerImg
  };
}
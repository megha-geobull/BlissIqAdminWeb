class LearningSlideModel {
  LearningSlideModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<LearningSlide> data;

  LearningSlideModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>LearningSlide.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class LearningSlide {
  LearningSlide({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.topicId,
    required this.subTopicId,
    required this.questionType,
    required this.title,
    required this.definition,
    required this.transcriptionOne,
    required this.grammarExamples,
    required this.transcriptionTwo,
    required this.points,
    required this.index,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String topicId;
  late final String subTopicId;
  late final String questionType;
  late final String title;
  late final String definition;
  late final String transcriptionOne;
  late final String grammarExamples;
  late final String transcriptionTwo;
  late final int points;
  late final int index;

  LearningSlide.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryId = json['main_category_id'];
    subCategoryId = json['sub_category_id'];
    topicId = json['topic_id'];
    subTopicId = json['sub_topic_id'];
    questionType = json['question_type'];
    title = json['title'];
    definition = json['definition'];
    transcriptionOne = json['transcription_one'];
    grammarExamples = json['grammar_examples'];
    transcriptionTwo = json['transcription_two'];
    points = json['points'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_category_id'] = mainCategoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['topic_id'] = topicId;
    _data['sub_topic_id'] = subTopicId;
    _data['question_type'] = questionType;
    _data['title'] = title;
    _data['definition'] = definition;
    _data['transcription_one'] = transcriptionOne;
    _data['grammar_examples'] = grammarExamples;
    _data['transcription_two'] = transcriptionTwo;
    _data['points'] = points;
    _data['index'] = index;
    return _data;
  }
}
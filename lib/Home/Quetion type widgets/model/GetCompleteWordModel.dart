class GetCompleteWordModel {
  GetCompleteWordModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<CompleteWordData> data;

  GetCompleteWordModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>CompleteWordData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CompleteWordData {
  CompleteWordData({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.subTopicId,
    required this.topicId,
    required this.questionType,
    required this.question,
    required this.title,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.answer,
    required this.points,
    required this.index,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String subTopicId;
  late final String topicId;
  late final String questionType;
  late final String question;
  late final String title;
  late final String optionA;
  late final String optionB;
  late final String optionC;
  late final String optionD;
  late final String answer;
  late final int points;
  late final int index;

  CompleteWordData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryId = json['main_category_id'];
    subCategoryId = json['sub_category_id'];
    subTopicId = json['sub_topic_id'];
    topicId = json['topic_id'];
    questionType = json['question_type'];
    question = json['question'];
    title = json['title'];
    optionA = json['option_a'];
    optionB = json['option_b'];
    optionC = json['option_c'];
    optionD = json['option_d'];
    answer = json['answer'];
    points = json['points'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_category_id'] = mainCategoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['sub_topic_id'] = subTopicId;
    _data['topic_id'] = topicId;
    _data['question_type'] = questionType;
    _data['question'] = question;
    _data['title'] = title;
    _data['option_a'] = optionA;
    _data['option_b'] = optionB;
    _data['option_c'] = optionC;
    _data['option_d'] = optionD;
    _data['answer'] = answer;
    _data['points'] = points;
    _data['index'] = index;
    return _data;
  }
}
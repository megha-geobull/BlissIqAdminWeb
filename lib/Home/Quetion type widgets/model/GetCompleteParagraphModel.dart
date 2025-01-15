class GetCompleteParagraphModel {
  GetCompleteParagraphModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<CompleteParaData> data;

  GetCompleteParagraphModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>CompleteParaData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CompleteParaData {
  CompleteParaData({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.topicId,
    required this.subTopicId,
    required this.questionType,
    required this.title,
    required this.question,
    required this.paragraphContent,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.optionE,
    required this.optionF,
    required this.answer,
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
  late final String question;
  late final String paragraphContent;
  late final String optionA;
  late final String optionB;
  late final String optionC;
  late final String optionD;
  late final String optionE;
  late final String optionF;
  late final String answer;
  late final int points;
  late final int index;

  CompleteParaData.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryId = json['main_category_id'];
    subCategoryId = json['sub_category_id'];
    topicId = json['topic_id'];
    subTopicId = json['sub_topic_id'];
    questionType = json['question_type'];
    title = json['title'];
    question = json['question'];
    paragraphContent = json['paragraph_content'];
    optionA = json['option_a'];
    optionB = json['option_b'];
    optionC = json['option_c'];
    optionD = json['option_d'];
    optionE = json['option_e'];
    optionF = json['option_f'];
    answer = json['answer'];
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
    _data['question'] = question;
    _data['paragraph_content'] = paragraphContent;
    _data['option_a'] = optionA;
    _data['option_b'] = optionB;
    _data['option_c'] = optionC;
    _data['option_d'] = optionD;
    _data['option_e'] = optionE;
    _data['option_f'] = optionF;
    _data['answer'] = answer;
    _data['points'] = points;
    _data['index'] = index;
    return _data;
  }
}
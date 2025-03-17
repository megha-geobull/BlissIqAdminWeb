class GetStoryPhrases {
  GetStoryPhrases({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<StoryPhrases> data;

  GetStoryPhrases.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>StoryPhrases.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class StoryPhrases {
  StoryPhrases({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.subTopicId,
    required this.topicId,
    required this.index,
    required this.title,
    required this.questionType,
    required this.passage,
    this.image,
    required this.imageName,
    required this.questionFormat,
    required this.points,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String subTopicId;
  late final String topicId;
  late final int index;
  late final String title;
  late final String questionType;
  late final String passage;
  late final Null image;
  late final String imageName;
  late final String questionFormat;
  late final int points;

  StoryPhrases.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryId = json['main_category_id'];
    subCategoryId = json['sub_category_id'];
    subTopicId = json['sub_topic_id'];
    topicId = json['topic_id'];
    index = json['index'];
    title = json['title'];
    questionType = json['question_type'];
    passage = json['passage'];
    image = null;
    imageName = json['image_name'];
    questionFormat = json['question_format'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_category_id'] = mainCategoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['sub_topic_id'] = subTopicId;
    _data['topic_id'] = topicId;
    _data['index'] = index;
    _data['title'] = title;
    _data['question_type'] = questionType;
    _data['passage'] = passage;
    _data['image'] = image;
    _data['image_name'] = imageName;
    _data['question_format'] = questionFormat;
    _data['points'] = points;
    return _data;
  }
}
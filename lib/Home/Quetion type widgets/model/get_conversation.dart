class Conversation {
  Conversation({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<Data> data;

  Conversation.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.subTopicId,
    required this.topicId,
    required this.questionType,
    required this.title,
    required this.botConversation,
    required this.userConversation,
    required this.userConversationType,
    required this.options,
    required this.answer,
    required this.points,
    required this.index,
    this.isEditing = false,

  });

  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String subTopicId;
  late final String topicId;
  late final String questionType;
  late final String title;
  late final String botConversation;
  late final String userConversation;
  late final String userConversationType;
  late final String options;
  late final String answer;
  late final int points;
  late final int index;
  late bool isEditing;

  Data.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    mainCategoryId = json['main_category_id'];
    subCategoryId = json['sub_category_id'];
    subTopicId = json['sub_topic_id'];
    topicId = json['topic_id'];
    questionType = json['question_type'];
    title = json['title'];
    botConversation = json['bot_conversation'];
    userConversation = json['user_conversation'];
    userConversationType = json['user_conversation_type'];
    options = json['options'];
    answer = json['answer'];
    points = json['points'];
    index = json['index'];
    isEditing=false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_category_id'] = mainCategoryId;
    _data['sub_category_id'] = subCategoryId;
    _data['sub_topic_id'] = subTopicId;
    _data['topic_id'] = topicId;
    _data['question_type'] = questionType;
    _data['title'] = title;
    _data['bot_conversation'] = botConversation;
    _data['user_conversation'] = userConversation;
    _data['user_conversation_type'] = userConversationType;
    _data['options'] = options;
    _data['answer'] = answer;
    _data['points'] = points;
    _data['index'] = index;
    return _data;
  }
}
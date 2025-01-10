class GetStoryPhrases {
  final int? status;
  final String? message;
  final List<StoryPhrases>? data;

  GetStoryPhrases({
    this.status,
    this.message,
    this.data,
  });

  GetStoryPhrases.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => StoryPhrases.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class StoryPhrases {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? subTopicId;
  final String? topicId;
  final int? index;
  final String? phraseName;
  final int? points;

  StoryPhrases({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.subTopicId,
    this.topicId,
    this.index,
    this.phraseName,
    this.points,
  });

  StoryPhrases.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        topicId = json['topic_id'] as String?,
        index = json['index'] as int?,
        phraseName = json['phrase_name'] as String?,
        points = json['points'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'sub_topic_id' : subTopicId,
    'topic_id' : topicId,
    'index' : index,
    'phrase_name' : phraseName,
    'points' : points
  };
}
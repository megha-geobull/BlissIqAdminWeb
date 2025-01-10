class GetStoryModel {
  final int? status;
  final String? message;
  final List<StoryData>? data;

  GetStoryModel({
    this.status,
    this.message,
    this.data,
  });

  GetStoryModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => StoryData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'message' : message,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class StoryData {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? subTopicId;
  final String? topicId;
  final String? storyTitle;
  final dynamic storyImg;
  final String? content;
  final int? points;
  final String? highlightWord;
  final int? index;

  StoryData({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.subTopicId,
    this.topicId,
    this.storyTitle,
    this.storyImg,
    this.content,
    this.points,
    this.highlightWord,
    this.index,
  });

  StoryData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        topicId = json['topic_id'] as String?,
        storyTitle = json['story_title'] as String?,
        storyImg = json['story_img'],
        content = json['content'] as String?,
        points = json['points'] as int?,
        highlightWord = json['highlight_word'] as String?,
        index = json['index'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'sub_topic_id' : subTopicId,
    'topic_id' : topicId,
    'story_title' : storyTitle,
    'story_img' : storyImg,
    'content' : content,
    'points' : points,
    'highlight_word' : highlightWord,
    'index' : index
  };
}

class PhrasesData {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? subTopicId;
  final String? topicId;
  final String? storyTitle;
  final dynamic storyImg;
  final String? content;
  final int? points;
  final String? highlightWord;
  final int? index;

  PhrasesData({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.subTopicId,
    this.topicId,
    this.storyTitle,
    this.storyImg,
    this.content,
    this.points,
    this.highlightWord,
    this.index,
  });

  PhrasesData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        topicId = json['topic_id'] as String?,
        storyTitle = json['story_title'] as String?,
        storyImg = json['story_img'],
        content = json['content'] as String?,
        points = json['points'] as int?,
        highlightWord = json['highlight_word'] as String?,
        index = json['index'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'sub_topic_id' : subTopicId,
    'topic_id' : topicId,
    'story_title' : storyTitle,
    'story_img' : storyImg,
    'content' : content,
    'points' : points,
    'highlight_word' : highlightWord,
    'index' : index
  };
}
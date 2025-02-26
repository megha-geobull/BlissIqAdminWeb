class ImagePuzzle {
  final int? status;
  final String? detail;
  final List<ImagePuzzleData>? data;

  ImagePuzzle({
    this.status,
    this.detail,
    this.data,
  });

  ImagePuzzle.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        detail = json['detail'] as String?,
        data = (json['data'] as List?)?.map((dynamic e) => ImagePuzzleData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'status' : status,
    'detail' : detail,
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class ImagePuzzleData {
  final String? id;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? topicId;
  final String? subTopicId;
  final int? points;
  final int? index;
  final String? questionType;
  final String? title;
  final List<Entries>? entries;

  ImagePuzzleData({
    this.id,
    this.mainCategoryId,
    this.subCategoryId,
    this.topicId,
    this.subTopicId,
    this.points,
    this.index,
    this.questionType,
    this.title,
    this.entries,
  });

  ImagePuzzleData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        mainCategoryId = json['main_category_id'] as String?,
        subCategoryId = json['sub_category_id'] as String?,
        topicId = json['topic_id'] as String?,
        subTopicId = json['sub_topic_id'] as String?,
        points = json['points'] as int?,
        index = json['index'] as int?,
        questionType = json['question_type'] as String?,
        title = json['title'] as String?,
        entries = (json['entries'] as List?)?.map((dynamic e) => Entries.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'main_category_id' : mainCategoryId,
    'sub_category_id' : subCategoryId,
    'topic_id' : topicId,
    'sub_topic_id' : subTopicId,
    'points' : points,
    'index' : index,
    'question_type' : questionType,
    'title' : title,
    'entries' : entries?.map((e) => e.toJson()).toList()
  };
}

class Entries {
  final String? id;
  final String? letter;
  final String? image;
  final String? imageName;

  Entries({
    this.id,
    this.letter,
    this.image,
    this.imageName,
  });

  Entries.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        letter = json['letter'] as String?,
        image = json['image'] as String?,
        imageName = json['image_name'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'letter' : letter,
    'image' : image,
    'image_name' : imageName
  };
}
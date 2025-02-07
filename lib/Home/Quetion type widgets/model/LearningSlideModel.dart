class LearningSlideModel {
  LearningSlideModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<LearningSlide> data;

  factory LearningSlideModel.fromJson(Map<String, dynamic> json) {
    return LearningSlideModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
          ?.map((e) => LearningSlide.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
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
    required this.pdfFile,
    required this.pptFile,
    required this.videoFile,
    required this.imageFile,
    required this.points,
    required this.index,
  });

   String id;
   String mainCategoryId;
   String subCategoryId;
   String topicId;
   String subTopicId;
   String questionType;
   String title;
   String definition;
   String pdfFile;
   String pptFile;
   String videoFile;
   String imageFile;
   int points;
   int index;

  factory LearningSlide.fromJson(Map<String, dynamic> json) {
    return LearningSlide(
      id: json['_id'] ?? '',
      mainCategoryId: json['main_category_id'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
      topicId: json['topic_id'] ?? '',
      subTopicId: json['sub_topic_id'] ?? '',
      questionType: json['question_type'] ?? '',
      title: json['title'] ?? '',
      definition: json['definition'] ?? '',
      pdfFile: json['pdf_file'] ?? '',
      pptFile: json['ppt_file'] ?? '',
      videoFile: json['video_file'] ?? '',
      imageFile: json['image_file'] ?? '',
      points: json['points'] ?? 0,
      index: json['index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'main_category_id': mainCategoryId,
      'sub_category_id': subCategoryId,
      'topic_id': topicId,
      'sub_topic_id': subTopicId,
      'question_type': questionType,
      'title': title,
      'definition': definition,
      'pdf_file': pdfFile,
      'ppt_file': pptFile,
      'video_file': videoFile,
      'image_file': imageFile,
      'points': points,
      'index': index,
    };
  }
}

class AllData {
  AllData({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<AllDatas> data;

  AllData.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>AllDatas.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AllDatas {
  AllDatas({
    required this.id,
    required this.categoryName,
    required this.categoryImg,
    required this.progress,
    required this.subCategories,
  });
  late final String id;
  late final String categoryName;
  late final String categoryImg;
  late final String progress;
  late final List<SubCategories> subCategories;

  AllDatas.fromJson(Map<String, dynamic> json){
    id = json['_id']??"";
    categoryName = json['category_name']??"";
    categoryImg = json['category_img']??"";
    progress = json['progress']??"";
    subCategories = List.from(json['sub_categories']??[]).map((e)=>SubCategories.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['category_name'] = categoryName;
    _data['category_img'] = categoryImg;
    _data['progress'] = progress;
    _data['sub_categories'] = subCategories.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SubCategories {
  SubCategories({
    required this.id,
    required this.mainCategoryId,
    required this.subCategory,
    required this.subcateImage,
    required this.progress,
    required this.topics,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategory;
  late final String subcateImage;
  late final String progress;
  late final List<Topics> topics;

  SubCategories.fromJson(Map<String, dynamic> json){
    id = json['_id']??"";
    mainCategoryId = json['main_categoryid']??"";
    subCategory = json['sub_category']??"";
    subcateImage = json['subcate_image']??"";
    progress = json['progress']??"";
    topics = List.from(json['topics']??[]).map((e)=>Topics.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_categoryid'] = mainCategoryId;
    _data['sub_category'] = subCategory;
    _data['subcate_image'] = subcateImage;
    _data['progress'] = progress;
    _data['topics'] = topics.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Topics {
  Topics({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.topicName,
    required this.progress,
    required this.subTopics,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String topicName;
  late final String progress;
  late final List<SubTopics> subTopics;

  Topics.fromJson(Map<String, dynamic> json){
    id = json['_id']??'';
    mainCategoryId = json['main_categoryid']??'';
    subCategoryId = json['sub_categoryid']??"";
    topicName = json['topic_name']??"";
    progress = json['progress']??'';
    subTopics = List.from(json['sub_topics']??[]).map((e)=>SubTopics.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_categoryid'] = mainCategoryId;
    _data['sub_categoryid'] = subCategoryId;
    _data['topic_name'] = topicName;
    _data['progress'] = progress;
    _data['sub_topics'] = subTopics.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SubTopics {
  SubTopics({
    required this.id,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.subTopicName,
    required this.topicId,
    required this.progress,
  });
  late final String id;
  late final String mainCategoryId;
  late final String subCategoryId;
  late final String subTopicName;
  late final String topicId;
  late final String progress;

  SubTopics.fromJson(Map<String, dynamic> json){
    id = json['_id']??"";
    mainCategoryId = json['main_categoryid']??"";
    subCategoryId = json['sub_categoryid']??"";
    subTopicName = json['sub_topic_name']??'';
    topicId = json['topicid']??'';
    progress = json['progress']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['main_categoryid'] = mainCategoryId;
    _data['sub_categoryid'] = subCategoryId;
    _data['sub_topic_name'] = subTopicName;
    _data['topicid'] = topicId;
    _data['progress'] = progress;
    return _data;
  }
}
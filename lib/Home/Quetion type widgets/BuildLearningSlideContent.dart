import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/QuestionController/QuestionApiController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BuildLearningSlideContent extends StatefulWidget {
  final String? main_category_id;
  final String? sub_category_id;
  final String? topic_id;
  final String? sub_topic_id;
  final String? question_type;
  final TextEditingController pointsController;

  const BuildLearningSlideContent({
    Key? key,
    required this.sub_topic_id,
    required this.topic_id,
    required this.sub_category_id,
    required this.main_category_id,
    required this.pointsController,
    required this.question_type
  }) : super(key: key);

  @override
  State<BuildLearningSlideContent> createState() => _BuildLearningSlideContentState();
}

class _BuildLearningSlideContentState extends State<BuildLearningSlideContent> {
  TextEditingController indexController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();

  TextEditingController definitionController = TextEditingController();
  TextEditingController transcription1Controller = TextEditingController();

  TextEditingController grammarExController = TextEditingController();
  TextEditingController transcription2Controller = TextEditingController();

  TextEditingController conclusionController = TextEditingController();
  TextEditingController transcription3Controller = TextEditingController();

  final QuestionApiController questionApiController = Get.put(QuestionApiController());

  void _submitSlideContent() {
    if (indexController.text.isEmpty ||
        titleController.text.isEmpty ||
        definitionController.text.isEmpty ||
        transcription1Controller.text.isEmpty ||
        grammarExController.text.isEmpty ||
        transcription2Controller.text.isEmpty ||
        int.tryParse(widget.pointsController.text) == null) {
      Fluttertoast.showToast(
        msg: 'Please fill all required fields with valid data.',
      );
      return;
    }

    int pointsValue = int.tryParse(widget.pointsController.text) ?? 0;

    questionApiController.addLearningSlideApi(
      mainCategoryId: widget.main_category_id!,
      subCategoryId: widget.sub_category_id!,
      topicId: widget.topic_id!,
      subTopicId: widget.sub_topic_id,
      question_type: widget.question_type.toString(),
      title: titleController.text,
      definition: definitionController.text,
      transcriptionOne: transcription1Controller.text,
      grammarExamples: grammarExController.text,
      transcriptionTwo: transcription2Controller.text,
      index: indexController.text,
      points: pointsValue.toString(),
    );

    indexController.clear();
    titleController.clear();
    definitionController.clear();
    transcription1Controller.clear();
    grammarExController.clear();
    transcription2Controller.clear();

  }


  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter index',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: CustomTextField(
                  controller: indexController,
                  maxLines: 1,
                  labelText: "Enter index",
                ),
              ),
              boxH10(),
              const Text(
                'Enter title',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: titleController,
                maxLines: 1,
                labelText: "Enter title",
              ),
              boxH10(),
              const Text(
                'Enter Definition',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: definitionController,
                maxLines: 2,
                labelText: "Enter Definition",
              ),
              boxH10(),
              const Text(
                'Enter transcription of Definition',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: transcription1Controller,
                maxLines: 3,
                labelText: "Enter transcription of definition",
              ),
              boxH10(),
              const Text(
                'Enter Example of Grammer',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: grammarExController,
                maxLines: 3,
                labelText: "Enter Example of Grammar",
              ),
              boxH10(),
              const Text(
                'Enter transcription of Examples',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: transcription2Controller,
                maxLines: 3,
                labelText: "Enter transcription of examples",
              ),
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: _submitSlideContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
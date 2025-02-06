import 'dart:convert';
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/QuestionController/QuestionApiController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
    required this.question_type,
  }) : super(key: key);

  @override
  State<BuildLearningSlideContent> createState() =>
      _BuildLearningSlideContentState();
}

class _BuildLearningSlideContentState extends State<BuildLearningSlideContent> {
  TextEditingController indexController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController definitionController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController pdfLinkController = TextEditingController();
  TextEditingController pptLinkController = TextEditingController();
  TextEditingController imageLinkController = TextEditingController();

  // Separate variables for different media types
  String? pdfFileName, pptFileName, imageFileName;
  String? pdfPath, pptPath, imagePath;
  Uint8List? pdfBytes, pptBytes, imageBytes;

  final QuestionApiController questionApiController =
  Get.put(QuestionApiController());

  void _submitSlideContent() async {
    if (indexController.text.isEmpty ||
        titleController.text.isEmpty ||
        definitionController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all required fields with valid data.',
      );
      return;
    }

    try {
      await questionApiController.addLearningSlideApi(
        mainCategoryId: widget.main_category_id!,
        subCategoryId: widget.sub_category_id!,
        topicId: widget.topic_id!,
        subTopicId: widget.sub_topic_id!, // Fixed subTopicId
        title: titleController.text,
        questionType: widget.question_type!,
        definition: definitionController.text,
        index: indexController.text,
        points: widget.pointsController.text,
     image_link: imageLinkController.text,
        ppt_link: pptLinkController.text,
        pdf_link:pdfLinkController.text ,
        youtubeLink: youtubeController.text,
      );

      // Clear all fields after successful submission
      indexController.clear();
      titleController.clear();
      definitionController.clear();
      youtubeController.clear();
      imageLinkController.clear();
      pptLinkController.clear();
      pdfLinkController.clear();

      setState(() {
        pdfFileName = pptFileName = imageFileName = null;
        pdfPath = pptPath = imagePath = null;
      });

      Fluttertoast.showToast(msg: 'Slide content added successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> _pickFile(List<String> extensions) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      withData: kIsWeb, // Ensure bytes are loaded on Web
    );

    if (result != null) {
      if (kIsWeb) {
        // Web: Use bytes
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        if (fileBytes != null) {
          setState(() {
            if (extensions.contains('pdf')) {
              pdfFileName = fileName;
              pdfBytes = fileBytes; // Store bytes
            } else if (extensions.contains('ppt') || extensions.contains('pptx')) {
              pptFileName = fileName;
              pptBytes = fileBytes;
            } else if (extensions.contains('jpg') ||
                extensions.contains('jpeg') ||
                extensions.contains('png')) {
              imageFileName = fileName;
              imageBytes = fileBytes;
            }
          });
        }
      } else {
        // Mobile: Use path
        String? filePath = result.files.first.path;
        String fileName = result.files.first.name;

        if (filePath != null) {
          setState(() {
            if (extensions.contains('pdf')) {
              pdfPath = filePath;
              pdfFileName = fileName;
            } else if (extensions.contains('ppt') || extensions.contains('pptx')) {
              pptPath = filePath;
              pptFileName = fileName;
            } else if (extensions.contains('jpg') ||
                extensions.contains('jpeg') ||
                extensions.contains('png')) {
              imagePath = filePath;
              imageFileName = fileName;
            }
          });
        }
      }

      Fluttertoast.showToast(msg: 'File uploaded successfully!');
    }
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
              _buildTextFieldSection('Enter index', indexController, 1),
              _buildTextFieldSection('Enter title', titleController, 1),
              _buildTextFieldSection('Enter Definition', definitionController, 2),
              _buildYouTubeSection(),
              boxH25(),
              CustomButton(label: "Add Question", onPressed: _submitSlideContent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldSection(
      String label, TextEditingController controller, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        boxH08(),
        maxLines == 1 && label == 'Enter index'
            ? SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
          child: CustomTextField(controller: controller, maxLines: maxLines, labelText: label),
        )
            : CustomTextField(controller: controller, maxLines: maxLines, labelText: label),
        boxH10(),
      ],
    );
  }

  // Widget _buildMediaOptionsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildYouTubeSection(),
  //       boxH15(),
  //       _buildFileUploadSection('PDF', ['pdf'], pdfFileName),
  //       boxH10(),
  //       _buildFileUploadSection('PPT', ['ppt', 'pptx'], pptFileName),
  //       boxH10(),
  //       _buildFileUploadSection('Image', ['jpg', 'jpeg', 'png'], imageFileName),
  //     ],
  //   );
  // }

  Widget _buildYouTubeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Video URL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        boxH08(),
        CustomTextField(controller: youtubeController, labelText: 'Provide  video URL', maxLines: 1),
        boxH10(),
        const Text('PDF URL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        boxH08(),
        CustomTextField(controller: pdfLinkController, labelText: 'Provide PDF URL', maxLines: 1),
        boxH10(),
        const Text('PPT URL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        boxH08(),
        CustomTextField(controller: pptLinkController, labelText: 'Provide PPT URL', maxLines: 1),
        boxH10(),
        const Text('Image URL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        boxH08(),
        CustomTextField(controller: imageLinkController, labelText: 'Provide image URL', maxLines: 1)
      ],
    );
  }

  Widget _buildFileUploadSection(
      String label, List<String> extensions, String? fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _pickFile(extensions),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[100],
            foregroundColor: Colors.orange[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('Upload $label', style: const TextStyle(color: Colors.black)),
        ),
        if (fileName != null)
          _buildUploadSuccessMessage('$label uploaded: $fileName'),
      ],
    );
  }

  Widget _buildUploadSuccessMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.green, fontSize: 14))),
        ],
      ),
    );
  }
}

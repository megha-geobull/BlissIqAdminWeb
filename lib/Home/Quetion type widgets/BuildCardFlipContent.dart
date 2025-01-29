import 'dart:typed_data';

import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/question_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildCardFlipContent extends StatefulWidget {
  final String? main_category_id;
  final String? sub_category_id;
  final String? topic_id;
  final String? sub_topic_id;
  final TextEditingController pointsController;

  const BuildCardFlipContent({
    Key? key,
    required this.sub_topic_id,
    required this.topic_id,
    required this.sub_category_id,
    required this.main_category_id,
    required this.pointsController,
  }) : super(key: key);

  @override
  State<BuildCardFlipContent> createState() => _BuildCardFlipContentState();
}

class _BuildCardFlipContentState extends State<BuildCardFlipContent> {
  List<TextEditingController> _textControllers = List.generate(6, (_) => TextEditingController());
  final QuestionController _questionController = Get.find();
  final List<Uint8List?> _imagesBytes = List.filled(6, null);
  final TextEditingController indexController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final List<String> imageNames = [];

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 0.8,
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
                'Upload Images and Corresponding Text',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH10(),
              for (int i = 0; i < 6; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickImage(i),
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: [4, 4],
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _imagesBytes[i] != null
                                ? Center(
                              child: Image.memory(
                                _imagesBytes[i]!,
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Center(child: Text('Upload Image')),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        controller: _textControllers[i],
                        maxLines: 1,
                        labelText: "Enter Text",
                      ),
                    ),
                  ],
                ),
                boxH10(),
              ],
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: () async {
                  // Filter out null values and convert to List<Uint8List>
                  List<Uint8List> validImages = _imagesBytes
                      .where((image) => image != null)
                      .cast<Uint8List>()
                      .toList();

                  _questionController.addFlipTheCard(
                    main_category_id: widget.main_category_id!,
                    sub_category_id: widget.sub_category_id!,
                    topic_id: widget.topic_id!,
                    sub_topic_id: widget.sub_topic_id!,
                    title: titleController.text,
                    points: widget.pointsController.text,
                    letters: _textControllers.map((controller) => controller.text).join('|'),
                    image_name: imageNames.isNotEmpty
                        ? imageNames.join("|")
                        : "",
                    images: validImages,
                    index: indexController.text,
                    context: context,
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    var pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      setState(() {
        // Generate a unique name using timestamp
        final imageName = 'image_${DateTime.now().millisecondsSinceEpoch}_$index.png';

        // Ensure the imageNames list has the same length as _imagesBytes
        if (imageNames.length <= index) {
          imageNames.addAll(List.filled(index - imageNames.length + 1, ''));
        }
        imageNames[index] = imageName;

        // Store the image bytes
        _imagesBytes[index] = pickedFile.files.first.bytes;
      });
    }
  }

}


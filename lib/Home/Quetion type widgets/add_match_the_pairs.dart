import 'dart:typed_data';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/question_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AddMatchPairs extends StatefulWidget {
  final String? main_category_id;
  final String? sub_category_id;
  final String? topic_id;
  final String? sub_topic_id;
  final TextEditingController pointsController;

  AddMatchPairs({
    this.main_category_id,
    this.sub_category_id,
    this.topic_id,
    this.sub_topic_id,
    required this.pointsController
  });

  @override
  _AddMatchPairsState createState() => _AddMatchPairsState();
}

class _AddMatchPairsState extends State<AddMatchPairs> {
  final List<TextImageSoundPair> leftColumnPairs =
  List.generate(5, (_) => TextImageSoundPair());
  final List<TextImageSoundPair> rightColumnPairs =
  List.generate(5, (_) => TextImageSoundPair());
  TextEditingController indexController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  QuestionController addQuestionController = Get.find();

  PairType leftColumnType = PairType.text;
  PairType rightColumnType = PairType.text;

  // List to store uploaded images
  final List<Uint8List?> uploadedImages = [];

  Future<void> _pickImage(TextImageSoundPair pair, int pairIndex) async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      setState(() {
        pair.imageBytes = imageBytes;
        // Add or update the image in the uploadedImages list
        if (uploadedImages.length > pairIndex) {
          uploadedImages[pairIndex] = imageBytes;
        } else {
          uploadedImages.add(imageBytes);
        }
      });
    }
  }

  void _updateColumnType(List<TextImageSoundPair> columnPairs, PairType type) {
    setState(() {
      for (var pair in columnPairs) {
        pair.type = type;
        if (type != PairType.image) {
          pair.imageBytes = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question Index:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: indexController,
              labelText: '',
              hintText: "0",
            ),
            boxH15(),
            const Text(
              'Question title:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: titleController,
              labelText: 'Enter question title here...',
            ),
            boxH15(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildColumn(
                      pairs: leftColumnPairs,
                      title: "Left Column",
                      selectedType: leftColumnType,
                      onTypeChanged: (type) {
                        leftColumnType = type;
                        _updateColumnType(leftColumnPairs, type);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildColumn(
                      pairs: rightColumnPairs,
                      title: "Right Column",
                      selectedType: rightColumnType,
                      onTypeChanged: (type) {
                        rightColumnType = type;
                        _updateColumnType(rightColumnPairs, type);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // Debug uploaded images
                    print(uploadedImages);
                    print(uploadedImages.length);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2,
                    shadowColor: Colors.orangeAccent,
                  ),
                  child: const Text(
                    'Add Question',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn({
    required List<TextImageSoundPair> pairs,
    required String title,
    required PairType selectedType,
    required ValueChanged<PairType> onTypeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<PairType>(
          value: selectedType,
          items: PairType.values.map((type) {
            return DropdownMenuItem<PairType>(
              value: type,
              child: Text(type.name),
            );
          }).toList(),
          onChanged: (type) => onTypeChanged(type!),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: pairs.length,
            itemBuilder: (context, index) {
              return _buildPairRow(pairs[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPairRow(TextImageSoundPair pair, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _buildInputField(pair, index),
    );
  }

  Widget _buildInputField(TextImageSoundPair pair, int index) {
    switch (pair.type) {
      case PairType.text:
        return CustomTextField(
          controller: pair.textController,
          labelText: "Enter text",
        );
      case PairType.sound:
        return CustomTextField(
          controller: pair.textController,
          labelText: "Enter sound for text",
          sufixIcon: const Icon(Icons.volume_up),
        );
      case PairType.image:
        return pair.imageBytes == null
            ? ElevatedButton(
          onPressed: () => _pickImage(pair, index),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: BorderSide(color: Colors.grey),
              backgroundColor: Colors.white,
              elevation: 0.5,
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 8)),
          child: const Text("Upload Image"),
        )
            : Image.memory(
          pair.imageBytes!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}


class TextImageSoundPair {
  PairType type;
  TextEditingController textController;
  Uint8List? imageBytes;

  TextImageSoundPair({
    this.type = PairType.text,
    TextEditingController? textController,
  }) : textController = textController ?? TextEditingController();
}

enum PairType { text, image, sound }

extension PairTypeExtension on PairType {
  String get name {
    switch (this) {
      case PairType.text:
        return "Text";
      case PairType.image:
        return "Image";
      case PairType.sound:
        return "Sound";
    }
  }
}

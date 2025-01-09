  import 'dart:io';
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

    // Separate lists to store uploaded images for question and answer columns
    final List<Uint8List> leftColumnImages = [];
    final List<Uint8List> rightColumnImages = [];

    // Separate lists to store image names for question and answer columns
    final List<String> leftColumnImageNames = [];
    final List<String> rightColumnImageNames = [];

    Future<void> _pickImage(TextImageSoundPair pair, int pairIndex, bool isLeftColumn) async {
      final imageBytes = await ImagePickerWeb.getImageAsBytes(); // Get the image bytes
      if (imageBytes != null) {
        final imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.png'; // Generate a unique name

        setState(() {
          pair.imageBytes = imageBytes;
          if (isLeftColumn) {
            // Add or update the image in the left column list
            if (leftColumnImages.length > pairIndex) {
              leftColumnImages[pairIndex] = imageBytes;
              leftColumnImageNames[pairIndex] = imageName; // Save the generated image name
            } else {
              leftColumnImages.add(imageBytes);
              leftColumnImageNames.add(imageName); // Save the generated image name
            }
          } else {
            // Add or update the image in the right column list
            if (rightColumnImages.length > pairIndex) {
              rightColumnImages[pairIndex] = imageBytes;
              rightColumnImageNames[pairIndex] = imageName; // Save the generated image name
            } else {
              rightColumnImages.add(imageBytes);
              rightColumnImageNames.add(imageName); // Save the generated image name
            }
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
                        isLeftColumn: true,
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
                        isLeftColumn: false,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      final questionIndex = indexController.text.trim();
                      final questionTitle = titleController.text.trim();
                      final points = widget.pointsController.text.trim();

                      // Collecting data for left and right pairs
                      final leftPairs = leftColumnPairs.map((pair) {
                        return pair.type == PairType.text
                            ? pair.textController.text.trim()
                            : '';
                      }).join('|');

                      final rightPairs = rightColumnPairs.map((pair) {
                        return pair.type == PairType.text
                            ? pair.textController.text.trim()
                            : '';
                      }).join('|');

                      // Images for left and right pairs
                      final leftImages = leftColumnPairs
                          .where((pair) =>
                      pair.type == PairType.image && pair.imageBytes != null)
                          .map((pair) => pair.imageBytes!)
                          .toList();

                      final rightImages = rightColumnPairs
                          .where((pair) =>
                      pair.type == PairType.image && pair.imageBytes != null)
                          .map((pair) => pair.imageBytes!)
                          .toList();

                      if (questionIndex.isEmpty ||
                          questionTitle.isEmpty ||
                          points.isEmpty ||
                          leftPairs.isEmpty ||
                          rightPairs.isEmpty) {
                        Fluttertoast.showToast(msg: "Please fill in all required fields");
                        return;
                      }
                      final String questionImgName = leftColumnImageNames.isNotEmpty
                          ? leftColumnImageNames.join("|")
                          : "";
                      final String answerImgName = rightColumnImageNames.isNotEmpty
                          ? rightColumnImageNames.join("|")
                          : "";

// Printing all the fields for debugging
                      print(questionImgName);
                      print(answerImgName);
                      print("Main Category ID: ${widget.main_category_id}");
                      print("Sub Category ID: ${widget.sub_category_id}");
                      print("Sub Topic ID: ${widget.sub_topic_id}");
                      print("Question Index: $questionIndex");
                      print("Question Title: $questionTitle");
                      print("Points: $points");
                      print("Left Pairs: $leftPairs");
                      print("Right Pairs: $rightPairs");
                      print("Left Images Count: ${leftImages.length}");
                      print("Right Images Count: ${rightImages.length}");
                      print("Question Type: Match Pairs");
                      print("Question Format: ${leftColumnType.name}");
                      print("Answer Format: ${rightColumnType.name}");
                      print("Question Format: ${leftColumnType.name}");
                      print("Answer Format: ${rightColumnType.name}");

                      try {
                        await addQuestionController.addMatchThePairs(
                          main_category_id: widget.main_category_id!,
                          sub_category_id: widget.sub_category_id!,
                          topic_id: "njsdfk",
                          sub_topic_id: widget.sub_topic_id,
                          title: questionTitle,
                          index: questionIndex,
                          question_type: "Match the pairs",
                          question_format: leftColumnType.name,
                          answer_format: rightColumnType.name,
                          points: points,
                          questions: leftPairs,
                          answers: rightPairs,
                          questionImages: leftColumnImages,
                          answerImages: rightColumnImages,
                          context: context,
                          questionImgNames: questionImgName,
                          answerImgNames: answerImgName,
                        );
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error: $e");
                      }
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
      required bool isLeftColumn,
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
                return _buildPairRow(pairs[index], index, isLeftColumn);
              },
            ),
          ),
        ],
      );
    }

    Widget _buildPairRow(TextImageSoundPair pair, int index, bool isLeftColumn) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildInputField(pair, index, isLeftColumn),
      );
    }

    Widget _buildInputField(TextImageSoundPair pair, int index, bool isLeftColumn) {
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
            onPressed: () => _pickImage(pair, index, isLeftColumn),
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

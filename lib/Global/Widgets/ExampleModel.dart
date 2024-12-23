import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageWithText {
  final XFile file; // Path to the selected image
  final String path; // Path to the selected image
  final Uint8List? bytes; // Path to the selected image
  String name; // Text for the image

  ImageWithText({required this.file,required this.path,required this.bytes, this.name = ''});
}
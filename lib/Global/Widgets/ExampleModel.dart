import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ImageWithText {
  final PlatformFile file; // Path to the selected image
  final String path; // Path to the selected image
  var bytes; // Path to the selected image
  String name; // Text for the image
  String imageName; // Text for the image

  ImageWithText({required this.file,required this.path,required this.bytes, this.name = '',required this.imageName});
}
import 'dart:typed_data';

class Note {
  final String locationName;
  final String description;
  final String imagePath;
  final Uint8List imageBytes;

  Note({
    required this.locationName,
    required this.description,
    required this.imagePath,
    required this.imageBytes,
  });
}

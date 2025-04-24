import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final List<Note> _notes = [];
  final ImagePicker _picker = ImagePicker();

  void _addNote() async {
    final TextEditingController locationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? imagePath;
    Uint8List? imageBytes;

    final Note? newNote = await showDialog<Note>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add Note'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 10),
                    if (imagePath != null && imagePath!.isNotEmpty && !kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.file(
                          File(imagePath!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageBytes != null && imageBytes!.isNotEmpty && kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.memory(
                          imageBytes!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          if (kIsWeb) {
                            imageBytes = await pickedFile.readAsBytes();
                          } else {
                            imagePath = pickedFile.path;
                          }
                          setStateDialog(() {});
                        }
                      },
                      child: const Text('Add Picture'),
                    ),
                    if (imagePath != null || imageBytes != null)
                      ElevatedButton(
                        onPressed: () {
                          setStateDialog(() {
                            imagePath = null;
                            imageBytes = null;
                          });
                        },
                        child: const Text('Delete Picture'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (locationController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      final note = Note(
                        locationName: locationController.text,
                        description: descriptionController.text,
                        imagePath: imagePath ?? '',
                        imageBytes: imageBytes ?? Uint8List(0),
                      );
                      Navigator.pop(context, note);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (newNote != null) {
      setState(() {
        _notes.add(newNote);
      });
    }
  }

  void _updateNote(int index) async {
    final TextEditingController locationController = TextEditingController(text: _notes[index].locationName);
    final TextEditingController descriptionController = TextEditingController(text: _notes[index].description);
    String? imagePath = _notes[index].imagePath;
    Uint8List? imageBytes = _notes[index].imageBytes;

    final Note? updatedNote = await showDialog<Note>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit Note'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 10),
                    if (imagePath != null && imagePath!.isNotEmpty && !kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.file(
                          File(imagePath!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageBytes != null && imageBytes!.isNotEmpty && kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.memory(
                          imageBytes!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          if (kIsWeb) {
                            imageBytes = await pickedFile.readAsBytes();
                          } else {
                            imagePath = pickedFile.path;
                          }
                          setStateDialog(() {});
                        }
                      },
                      child: const Text('Change Picture'),
                    ),
                    if (imagePath != null || imageBytes != null)
                      ElevatedButton(
                        onPressed: () {
                          setStateDialog(() {
                            imagePath = null;
                            imageBytes = null;
                          });
                        },
                        child: const Text('Delete Picture'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (locationController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      final note = Note(
                        locationName: locationController.text,
                        description: descriptionController.text,
                        imagePath: imagePath ?? '',
                        imageBytes: imageBytes ?? Uint8List(0),
                      );
                      Navigator.pop(context, note);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedNote != null) {
      setState(() {
        _notes[index] = updatedNote;
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Notes'),
        backgroundColor: Colors.blue,
      ),
      body: _notes.isEmpty
          ? const Center(
        child: Text(
          'No notes added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                note.locationName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.description),
                  if (note.imagePath.isNotEmpty && !kIsWeb)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.file(
                        File(note.imagePath),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (note.imageBytes.isNotEmpty && kIsWeb)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.memory(
                        note.imageBytes,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _updateNote(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

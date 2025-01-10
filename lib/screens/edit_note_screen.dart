import 'package:flutter/material.dart';
import 'package:flutter_final_project/models/note_model.dart';
import 'package:flutter_final_project/services/supabase_service.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;

  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
  }

  void _updateNote() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
      );
      return;
    }

    final success = await SupabaseService.updateNote(
      widget.note.id,
      title,
      description, isFinished: false,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update note')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateNote,
              child: const Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}

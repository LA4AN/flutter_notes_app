import 'package:flutter/material.dart';
import 'package:flutter_final_project/models/note_model.dart';
import 'package:flutter_final_project/screens/view_note_screen.dart'; // Import the ViewNoteScreen
import 'package:flutter_final_project/services/supabase_service.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NoteModel>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    _notesFuture = SupabaseService.fetchNotes();
  }

  Future<void> _deleteNote(String id) async {
    try {
      await SupabaseService.deleteNote(id);
      setState(() {
        _loadNotes(); // Refresh the notes after deletion
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete note')),
      );
    }
  }

  Future<void> _markAsFinished(NoteModel note) async {
    try {
      // Toggle the isFinished value
      await SupabaseService.updateNote(
        note.id,
        note.title,
        note.description,
        isFinished: !note.isFinished, // Toggling isFinished
      );
      // Refresh the notes after updating
      setState(() {
        _loadNotes();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update note')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: FutureBuilder<List<NoteModel>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('No notes available.'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: TextStyle(
                      decoration: note.isFinished
                          ? TextDecoration.lineThrough
                          : null, // Strike-through if finished
                    ),
                  ),
                  subtitle: Text(note.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: note.isFinished, // Binding the checkbox value
                        onChanged: (_) {
                          // Handle the toggle action
                          _markAsFinished(note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNoteScreen(note: note),
                            ),
                          ).then((_) {
                            setState(() {
                              _loadNotes();
                            });
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(note.id),
                      ),
                      // Add an icon to navigate to the view note screen
                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewNoteScreen(note: note),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          ).then((_) {
            setState(() {
              _loadNotes();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

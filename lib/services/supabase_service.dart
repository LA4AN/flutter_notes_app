import 'package:flutter_final_project/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Fetch all notes
  static Future<List<NoteModel>> fetchNotes() async {
    final response = await _client
        .from('notes')
        .select('*')
        .order('created_at', ascending: false)
        .execute();

    if (response.error != null) {
      throw Exception('Error fetching notes: ${response.error!.message}');
    }

    final data = response.data as List<dynamic>?;
    if (data == null) {
      return [];
    }

    return data
        .map((e) => NoteModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // Add a new note
  static Future<bool> addNote(String title, String description) async {
    final response = await _client.from('notes').insert({
      'title': title,
      'description': description,
    }).execute();

    if (response.error != null) {
      print('Error adding note: ${response.error!.message}');
      return false;
    }

    return true;
  }


// Update an existing note
static Future<bool> updateNote(
  String id,
  String title,
  String description, {
  bool? isFinished,
}) async {
  final updateData = {
    'title': title,
    'description': description,
    if (isFinished != null) 'is_finished': isFinished,  // Include isFinished only if it's not null
  };

  final response = await _client
      .from('notes')
      .update(updateData)  // Using the updateData with isFinished if needed
      .eq('id', id)
      .execute();

  if (response.error != null) {
    print('Error updating note: ${response.error!.message}');
    return false;
  }

  return true;
}


  // Delete a note
  static Future<bool> deleteNote(String id) async {
    final response =
        await _client.from('notes').delete().eq('id', id).execute();

    if (response.error != null) {
      print('Error deleting note: ${response.error!.message}');
      return false;
    }

    return true;
  }
}

extension on PostgrestResponse {
  get error => null;
}

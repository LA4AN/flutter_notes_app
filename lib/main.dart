import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/add_note_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

final supabaseUrl = dotenv.env['https://atdmdzgepevlrtjwuuij.supabase.co'];
final supabaseAnonKey = dotenv.env[
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0ZG1kemdlcGV2bHJ0and1dWlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0NDIyMTEsImV4cCI6MjA1MDAxODIxMX0.ixO5Lm332e-y9hD-BsYgdeg8Au4pofvwQ6cf9yFxcJg'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception("Supabase URL or anonKey is not set in the .env file");
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddNoteScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_admin/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url:
        'https://ahcqrvfhuwbhiobgjjts.supabase.co', // Ganti dengan URL Supabase project Anda
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFoY3FydmZodXdiaGlvYmdqanRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyMjkwNDQsImV4cCI6MjA4MzgwNTA0NH0.47DuZTmE8WNCPVXmqeg1mQYkWKw0166izQNmsddy054', // Ganti dengan Anon Key Supabase Anda
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AdminDashboard(),
    );
  }
}
  
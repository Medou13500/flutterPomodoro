import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentification/connexion.dart';
import 'timer/timer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fyzcvuvivdwfinrvzrbx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ5emN2dXZpdmR3ZmlucnZ6cmJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1MzI3NjgsImV4cCI6MjA2NzEwODc2OH0.s_Frfy6Kqoz0ImxIAatT9YVhwnKC0l_SCD0nTNrU1EM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConnexionScreen(),
    );
  }
}

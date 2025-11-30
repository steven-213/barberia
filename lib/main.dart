import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/calendario_page.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';// tu calendario


const supabaseUrl = 'https://bsmejavaoambjdtpktgw.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzbWVqYXZhb2FtYmpkdHBrdGd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzM4NjIsImV4cCI6MjA3OTUwOTg2Mn0.JR1voF8y-RT3tFJk962LypOIcnP0m6852fgy_I0QJ5c';

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),

      routes: {
        '/agenda': (context) => CalendarioCitasPage(),
        '/whatsapp': (context) => const HomePage(),
      },
    );
  }
}

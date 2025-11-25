import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/calendario_page.dart'; // tu calendario

void main() {
  runApp(const MyApp());
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

import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FlowlyticsApp());
}

class FlowlyticsApp extends StatelessWidget {
  const FlowlyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flowlytics - Herramientas de Análisis Empresarial',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

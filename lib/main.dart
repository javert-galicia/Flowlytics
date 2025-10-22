import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const BusinessAnalysisApp());
}

class BusinessAnalysisApp extends StatelessWidget {
  const BusinessAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herramientas de Análisis Empresarial',
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

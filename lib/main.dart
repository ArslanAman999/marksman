import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Greeting_Page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp( // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EcomApp()); // Run your app
}
class EcomApp extends StatefulWidget {
  const EcomApp({super.key});

  @override
  State<EcomApp> createState() => _EcomAppState();
}

class _EcomAppState extends State<EcomApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GreatingPage(),
    );
  }}
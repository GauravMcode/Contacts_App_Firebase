import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "firebase_options.dart";
import 'screens/HomePage.dart';

//https://stackoverflow.com/questions/59529428/flutter-java-uses-or-overrides-a-deprecated-api

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase Database",
      theme: ThemeData(primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

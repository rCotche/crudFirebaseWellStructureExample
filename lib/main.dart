import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_example_firebase_well_structured/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();

  //
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //cache the data on device
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(
            210,
            224,
            251,
            1,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

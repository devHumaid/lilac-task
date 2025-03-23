import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/screens/home_page.dart';
import 'package:task/provider/main_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
         theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white, // Set background color globally
        useMaterial3: true,
        
      ),
      home: HomePage(),
      )
    );
  }
}

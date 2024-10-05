import 'package:flutter/material.dart';
import 'package:sqf_lite_crude/auth/register.dart';
import 'package:sqf_lite_crude/auth/sign_in.dart';
import 'package:sqf_lite_crude/auth/splace_screen.dart';
import 'package:sqf_lite_crude/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      home: const SplaceScreen(),
    );
  }
}



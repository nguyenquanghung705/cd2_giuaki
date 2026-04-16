import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/news_view_model.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel()..initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal News App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            margin: EdgeInsets.zero,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
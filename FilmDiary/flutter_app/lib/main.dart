
import 'package:flutter/material.dart';
import 'screens/schermata_principale.dart';

void main() {
  runApp(const AppFilmDiary());
}

class AppFilmDiary extends StatelessWidget {
  const AppFilmDiary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                    'FilmDiary',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme:  ColorScheme.fromSeed(
          seedColor:  const Color(0xFFB71C1C),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled:    true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:   const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:   const BorderSide(color: Colors.white24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation:       0,
          centerTitle:     true,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2A2A2A),
          selectedColor:   const Color(0xFFB71C1C).withOpacity(0.3),
          labelStyle:      const TextStyle(fontSize: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      home: const SchermataPrincipale(),
    );
  }
}

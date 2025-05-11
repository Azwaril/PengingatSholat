import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return MaterialApp(
      title: 'Pengingat Sholat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Tema terang
      darkTheme: ThemeData.dark(), // Tema gelap
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Switch berdasarkan pilihan
      home: SplashScreen(),
    );
  }
}

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}

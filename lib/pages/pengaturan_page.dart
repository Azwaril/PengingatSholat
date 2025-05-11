import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Tampilan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Mode Gelap
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                title: const Text('Mode Gelap'),
                secondary: Icon(
                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.teal,
                ),
                activeColor: Colors.teal,
                value: settings.isDarkMode,
                onChanged: (value) {
                  settings.toggleTheme(value);
                },
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Info Versi Aplikasi
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                leading: Icon(Icons.info_outline, color: Colors.teal),
                title: Text('Versi Aplikasi'),
                subtitle: Text('1.0.0'),
              ),
            ),

            // Info Pengembang
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                leading: Icon(Icons.person, color: Colors.teal),
                title: Text('Pengembang'),
                subtitle: Text('Mas Aril'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

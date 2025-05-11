import 'package:flutter/material.dart';
import 'jadwal_sholat_page.dart';
import 'kalkulator_zakat_page.dart';
import 'pengaturan_page.dart';
import '../widgets/menu_item.dart';

class HomePage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem('Jadwal Sholat', Icons.access_time, JadwalSholatPage()),
    MenuItem('Kalkulator Zakat', Icons.calculate, KalkulatorZakatPage()),
    MenuItem('Pengaturan', Icons.settings, PengaturanPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade800,
        automaticallyImplyLeading: false,
        // Tombol kompas kiblat dihapus
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pengingat Sholat',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: menuItems.map((item) {
                  return item.build(context);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

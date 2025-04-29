import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pengingatsholat/main.dart';

void main() {
  testWidgets('HomePage widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());  // Jangan gunakan `const`

    // Verifikasi bahwa widget yang diharapkan ada.
    expect(find.text('Pengingat Sholat'), findsOneWidget);
    expect(find.byIcon(Icons.access_time), findsOneWidget);  // Cek ikon jadwal sholat

    // Contoh tes lainnya (jika diperlukan)
    // Misalnya, cek apakah ada tombol tertentu atau komponen lainnya.
  });
}

import 'package:flutter/material.dart';

class KalkulatorZakatPage extends StatefulWidget {
  @override
  _KalkulatorZakatPageState createState() => _KalkulatorZakatPageState();
}

class _KalkulatorZakatPageState extends State<KalkulatorZakatPage> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController debtController = TextEditingController();
  double zakat = 0;

  void _hitungZakat() {
    final double harta = double.tryParse(incomeController.text) ?? 0;
    final double utang = double.tryParse(debtController.text) ?? 0;
    final double total = harta - utang;

    setState(() {
      zakat = total > 0 ? total * 0.025 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Kalkulator Zakat',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Hitung Zakat Anda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      controller: incomeController,
                      label: 'Jumlah Harta (Rp)',
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: debtController,
                      label: 'Jumlah Utang (Rp)',
                      icon: Icons.money_off,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _hitungZakat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.calculate),
                      label: const Text(
                        'Hitung Zakat',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (zakat > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.shade300),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Zakat yang harus dibayarkan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rp ${zakat.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

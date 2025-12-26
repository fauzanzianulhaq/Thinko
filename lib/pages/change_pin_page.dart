import 'package:flutter/material.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  
  // Fungsi logika simpan (simulasi)
  void _handleSave() {
    // Disini nanti logika validasi PIN (misal: PIN baru harus sama dengan konfirmasi)
    Navigator.pop(context); // Kembali ke profil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PIN berhasil diganti!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ganti PIN",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 1. GAMBAR ROBOT
            Center(
              child: SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/logo_thinko.png', // Pastikan nama file gambar robot benar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. FORM INPUT PIN
            
            // A. PIN LAMA
            const Text("PIN Lama", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(),

            const SizedBox(height: 20),

            // B. PIN BARU
            const Text("PIN Baru", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(),

            const SizedBox(height: 20),

            // C. KONFIRMASI PIN
            const Text("Tulis Ulang PIN Baru", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildPinInputRow(),

            const SizedBox(height: 40),

            // 3. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CC600), // Hijau
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PEMBUAT 4 KOTAK PIN ---
  Widget _buildPinInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return Container(
          width: 70, // Lebar kotak
          height: 70, // Tinggi kotak
          decoration: BoxDecoration(
            color: Colors.grey[200], // Warna abu muda
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            obscureText: true, // Biar jadi titik-titik (rahasia)
            maxLength: 1, // Cuma bisa isi 1 angka per kotak
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: "", // Hilangkan counter angka kecil di bawah
              border: InputBorder.none, // Hilangkan garis bawah
            ),
            // Logika sederhana: kalau diketik, pindah fokus (opsional, bisa dikembangkan)
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
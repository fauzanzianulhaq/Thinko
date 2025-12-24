import 'package:flutter/material.dart';
import 'pin_confirmation_page.dart';

class PinCreationPage extends StatefulWidget {
  const PinCreationPage({super.key});

  @override
  State<PinCreationPage> createState() => _PinCreationPageState();
}

class _PinCreationPageState extends State<PinCreationPage> {
  // Kita butuh 4 controller untuk masing-masing kotak
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Status apakah PIN terlihat atau tersembunyi
  bool _isPinVisible = true; // Sesuai gambar, awalnya terlihat (angka 1 dan 3 kelihatan)

  @override
  void dispose() {
    // Bersihkan memori saat halaman ditutup
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD0F8CE), // Hijau muda
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 1. Header: Tombol Kembali
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Kembali",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Progress Bar (2 Hijau, 1 Abu)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    // Step 1: Hijau
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1CC600),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Step 2: Hijau (Halaman ini)
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1CC600),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Step 3: Abu-abu
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      
                      // Logo Robot
                      Image.asset(
                        'assets/images/logo_thinko2.png',
                        height: 120,
                      ),
                      
                      const SizedBox(height: 20),

                      const Text(
                        'Hampir selesai\nSekarang buat PIN rahasia\nbiar akunmu aman.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 3. Input PIN 4 Kotak
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 70,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300], // Warna abu kotak
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              obscureText: !_isPinVisible, // Logic sembunyi/lihat
                              obscuringCharacter: '●', // Karakter pengganti jika hidden
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: "", 
                              ),
                              maxLength: 1,
                              onChanged: (value) {
                                // Logic Auto-Focus: Pindah ke kotak sebelah kalau sudah diisi
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                // Kalau dihapus (kosong), pindah mundur ke kotak sebelumnya
                                if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // 4. Ikon Mata (Toggle Visibility)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPinVisible = !_isPinVisible; // Ubah status true/false
                          });
                        },
                        child: Icon(
                          _isPinVisible ? Icons.visibility_off : Icons.visibility,
                          size: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Tombol Lanjut
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                  String pin = _controllers.map((c) => c.text).join();
  
                if (pin.length == 4) {
                  // Kirim PIN ke halaman Konfirmasi
                Navigator.push(
                  context,
                MaterialPageRoute(
                       builder: (context) => PinConfirmationPage(sourcePin: pin),
                ),
                );
              } else {
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN harus 4 digit ya!')),
              );
          }
          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CC600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
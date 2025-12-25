import 'package:flutter/material.dart';

class Level8Page extends StatefulWidget {
  const Level8Page({super.key});

  @override
  State<Level8Page> createState() => _Level8PageState();
}

class _Level8PageState extends State<Level8Page> {
  // --- DATA SOAL ---
  final String question = "5 + 6";
  final int correctAnswer = 11;
  final List<int> options = [9, 6, 11, 10]; 

  // --- STATUS GAME ---
  int userHealth = 100;
  double bossHealth = 1.0; // 1.0 artinya 100% penuh

  // Logika Cek Jawaban
  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      // JAWABAN BENAR: Kurangi darah Boss
      setState(() {
        bossHealth -= 0.2; // Kurangi 20%
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Serangan Berhasil!"), 
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
        ),
      );

      // Cek apakah Boss kalah (Health habis)
      if (bossHealth <= 0.05) { 
        _showWinDialog();
      }

    } else {
      // JAWABAN SALAH: Kurangi darah User
      setState(() {
        userHealth -= 10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aduh! Jawaban salah!"), 
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  // Dialog Menang
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Level Selesai! 🎉"),
        content: const Text("Kamu berhasil mengalahkan monster gurun ini!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup Dialog
              Navigator.pop(context); // Kembali ke Peta (Home)
            },
            child: const Text("Lanjut"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND (hutan.png)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/region_2/gurun.png'),
                fit: BoxFit.cover, // Agar gambar memenuhi layar
              ),
            ),
          ),

          // 2. TAMPILAN UI (Safe Area)
          SafeArea(
            child: Column(
              children: [
                // --- HEADER: HP BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Avatar User
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/mc.png'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      // HP User Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          "$userHealth",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      
                      const Spacer(),

                      // HP Boss Bar (Kanan)
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            // Background Bar Putih
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black54),
                              ),
                            ),
                            // Isi Darah Merah
                            FractionallySizedBox(
                              widthFactor: bossHealth > 0 ? bossHealth : 0, // Cegah error minus
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // Icon Boss Kecil (Opsional: Pakai gambar monster lagi tapi kecil)
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/region_2/monster_lvl_8.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // --- ARENA KARAKTER (FIX GARIS KUNING) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end, 
                    children: [
                      // HERO (Kiri)
                      Flexible(
                        child: Image.asset(
                          'assets/images/mc.png',
                          height: 150, // Tinggi maksimal
                          fit: BoxFit.contain, // Agar gambar tidak gepeng
                        ),
                      ),
                      
                      const SizedBox(width: 10), // Jarak aman

                      // MUSUH (Kanan)
                      Flexible(
                        child: Image.asset(
                          'assets/images/region_2/monster_lvl_8.png',
                          height: 180, // Monster biasanya lebih besar sedikit
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- KOTAK SOAL ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    question, // "5 + 6"
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- OPSI JAWABAN ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: options.map((option) {
                      return GestureDetector(
                        onTap: () => checkAnswer(option),
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "$option",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // 1. WAJIB IMPORT INI
import 'level_6_page.dart'; // Pastikan file ini sudah ada, atau comment dulu kalau belum

class Level5Page extends StatefulWidget {
  const Level5Page({super.key});

  @override
  State<Level5Page> createState() => _Level5PageState();
}

class _Level5PageState extends State<Level5Page> {
  // --- DATA SOAL LEVEL 5 ---
  final String question = "30 + 25 - 10";
  final int correctAnswer = 45;
  final List<int> options = [40, 30, 45, 35];

  // --- STATUS GAME ---
  int userHealth = 100;
  double bossHealth = 1.0;
  bool isGameFinished = false; // 2. TAMBAH VARIABLE INI (Biar gak error double klik)

  // Logika Cek Jawaban
  void checkAnswer(int selectedAnswer) {
    if (isGameFinished) return; // Kalau game selesai, tombol macet (biar aman)

    if (selectedAnswer == correctAnswer) {
      // JAWABAN BENAR
      setState(() {
        bossHealth -= 0.2; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Serangan Telak! Golem Es retak!"), 
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
        ),
      );

      // Cek Menang
      if (bossHealth <= 0.05) {
        setState(() {
          isGameFinished = true; // Tandai game selesai
          bossHealth = 0;
        });

        // 3. SOLUSI ERROR "NAVIGATOR LOCKED"
        // Gunakan SchedulerBinding agar dialog muncul SETELAH layar selesai digambar
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showWinDialog();
        });
      }

    } else {
      // JAWABAN SALAH
      setState(() {
        userHealth -= 15; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Brrr! Dingin! Jawabanmu salah!"), 
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  // --- POPUP KEMENANGAN ---
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // KOTAK KONTEN
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "STAGE SELESAI !",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 10),
                    
                    // Subtitle
                    const Text(
                      "Luar biasa! Golem Es berhasil dicairkan!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Bintang & Skor
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, color: Colors.amber, size: 36),
                          SizedBox(width: 8),
                          Text("5", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol Navigasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Tombol Peta
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // Tutup Dialog
                            Navigator.pop(context); // Balik ke Peta
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                                child: Icon(Icons.list_alt_rounded, color: Colors.green[700], size: 30),
                              ),
                              const SizedBox(height: 4),
                              const Text("Peta", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        // Tombol Stage Berikutnya (Ke Level 6)
                        InkWell(
                          onTap: () {
                             Navigator.pop(context); // Tutup dialog
                             // Ganti halaman ke Level 6
                             // Pastikan file level_6_page.dart sudah dibuat ya!
                             Navigator.pushReplacement(
                               context, 
                               MaterialPageRoute(builder: (context) => const Level6Page())
                             );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                                child: Icon(Icons.skip_next_rounded, color: Colors.green[700], size: 30),
                              ),
                              const SizedBox(height: 4),
                              const Text("Stage berikutnya", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // KEPALA ROBOT
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo_thinko.png'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND (Pastikan nama file background benar)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hutan.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. UI GAME
          SafeArea(
            child: Column(
              children: [
                // HEADER HP
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/mc.png'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
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
                      // Boss HP Bar
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black54),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: bossHealth > 0 ? bossHealth : 0,
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // Icon Boss Kecil
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/monster_level_5.png'), // Sesuaikan nama file monster
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ARENA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // HERO
                      Flexible(
                        child: Image.asset(
                          'assets/images/mc.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // MUSUH (Golem Es / Level 5)
                      Flexible(
                        child: Image.asset(
                          'assets/images/monster_level_5.png', // Sesuaikan nama file monster
                          height: 170, 
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SOAL
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),

                const SizedBox(height: 20),

                // OPSI JAWABAN
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
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
                          ),
                          child: Center(
                            child: Text(
                              "$option",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
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
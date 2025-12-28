import 'dart:async'; // Timer
import 'dart:math';  // Random
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Wajib untuk fix navigasi
import 'level_5_page.dart'; // Pastikan kamu sudah buat file level 5

class Level4Page extends StatefulWidget {
  const Level4Page({super.key});

  @override
  State<Level4Page> createState() => _Level4PageState();
}

class _Level4PageState extends State<Level4Page> {
  // --- KONFIGURASI LEVEL 4 (THEMA ES / ICE) ---
  final int enemyAttackSpeedMs = 1200; // Serangan tiap 1.2 detik
  final int enemyDamage = 7;           // Damage Golem Es sakit!
  final double userDamage = 0.2;       // Butuh 5x benar untuk menang

  // --- STATE GAME ---
  int userHealth = 100;
  double bossHealth = 1.0; 
  Timer? _enemyAttackTimer;
  bool _isStunned = false; 
  bool isGameFinished = false;

  // --- DATA SOAL DINAMIS ---
  String question = "";
  int correctAnswer = 0;
  List<int> options = [];

  @override
  void initState() {
    super.initState();
    _generateQuestion(); 
    _startEnemyAttack(); 
  }

  @override
  void dispose() {
    _enemyAttackTimer?.cancel(); 
    super.dispose();
  }

  // --- LOGIKA MUSUH MENYERANG ---
  void _startEnemyAttack() {
    _enemyAttackTimer = Timer.periodic(Duration(milliseconds: enemyAttackSpeedMs), (timer) {
      if (userHealth > 0 && bossHealth > 0.05 && !isGameFinished) {
        setState(() {
          userHealth -= enemyDamage;
        });

        if (userHealth <= 0) {
          userHealth = 0;
          timer.cancel();
          _showGameOverDialog();
        }
      }
    });
  }

  // --- LOGIKA SOAL (Level 4: Tanda Kurung / Prioritas) ---
  void _generateQuestion() {
    Random random = Random();
    // Sekarang ada 4 tipe soal:
    // 0: (A+B)xC
    // 1: (A-B):C
    // 2: (A+B)-C  <-- Baru
    // 3: A-(B+C)  <-- Baru
    int type = random.nextInt(4); 
    int a, b, c;

    if (type == 0) {
      // TIPE 1: Perkalian dengan Penjumlahan dalam kurung
      // (A + B) x C
      a = random.nextInt(10) + 1; 
      b = random.nextInt(10) + 1; 
      c = random.nextInt(5) + 2;  // Pengali 2-6
      
      question = "($a + $b) × $c";
      correctAnswer = (a + b) * c;

    } else if (type == 1) {
      // TIPE 2: Pembagian dengan Pengurangan dalam kurung
      // (A - B) : C
      c = random.nextInt(5) + 2;       // Pembagi
      int hasil = random.nextInt(10) + 2; 
      int selisih = c * hasil;         // Ini nilai (A-B)
      
      b = random.nextInt(10) + 1;
      a = selisih + b;                 // Jadi A - B = selisih
      
      question = "($a - $b) : $c";
      correctAnswer = hasil;

    } else if (type == 2) {
      // TIPE 3 (BARU): Penjumlahan dalam kurung lalu dikurang
      // (A + B) - C
      a = random.nextInt(20) + 10; 
      b = random.nextInt(20) + 5; 
      int sum = a + b;
      c = random.nextInt(sum - 5) + 1; // Pastikan hasil positif
      
      question = "($a + $b) - $c";
      correctAnswer = sum - c;

    } else {
      // TIPE 4 (BARU): Dikurang hasil penjumlahan dalam kurung
      // A - (B + C)  --> Ini mengajarkan prioritas kurung
      b = random.nextInt(15) + 5;
      c = random.nextInt(15) + 5;
      int sumInside = b + c;
      a = sumInside + random.nextInt(20) + 5; // A harus lebih besar dari (B+C)
      
      question = "$a - ($b + $c)";
      correctAnswer = a - sumInside;
    }

    // Generate Opsi Jawaban
    Set<int> optionsSet = {correctAnswer};
    while (optionsSet.length < 4) {
      int offset = random.nextInt(5) + 1;
      optionsSet.add(random.nextBool() ? correctAnswer + offset : correctAnswer - offset);
    }
    options = optionsSet.toList()..shuffle();
    
    if (mounted) setState(() {});
  }

  // --- CEK JAWABAN ---
  void checkAnswer(int selectedAnswer) {
    if (isGameFinished || _isStunned) return; 

    if (selectedAnswer == correctAnswer) {
      // BENAR
      setState(() {
        bossHealth -= userDamage; 
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Panas! Golem Es meleleh!"), 
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ),
      );

      // Cek Menang
      if (bossHealth <= 0.05) {
        setState(() {
          bossHealth = 0;
          isGameFinished = true;
        });
        _enemyAttackTimer?.cancel();

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showWinDialog();
        });
      } else {
        _generateQuestion(); 
      }

    } else {
      // SALAH -> Kena Stun (Beku)
      setState(() {
        _isStunned = true; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salah! Kamu membeku (Stun)!"),
          backgroundColor: Colors.cyan, // Warna biru es
          duration: Duration(milliseconds: 500),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isStunned = false; 
            _generateQuestion(); 
          });
        }
      });
    }
  }

  // --- GAME OVER ---
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over! ❄️", style: TextStyle(color: Colors.blue)),
        content: const Text("Kamu membeku dikalahkan Golem Es!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); 
            },
            child: const Text("Keluar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                userHealth = 100;
                bossHealth = 1.0;
                isGameFinished = false;
                _isStunned = false;
                _generateQuestion();
                _startEnemyAttack();
              });
            },
            child: const Text("Coba Lagi"),
          )
        ],
      ),
    );
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
              // 1. KOTAK KONTEN
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
                    
                    const Text(
                      "Hebat! Golem Es berhasil dihancurkan!",
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
                          Text("15", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                        // Tombol Stage Berikutnya (MENUJU LEVEL 5)
                        InkWell(
                          onTap: () {
                             Navigator.pop(context); 
                             Navigator.pushReplacement(
                               context, 
                               MaterialPageRoute(builder: (context) => const Level5Page())
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

              // 2. KEPALA ROBOT
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
          // BACKGROUND (Ganti ke Background Es jika ada, misal: snow.png)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hutan.png'), // Atau ganti 'ice_bg.png'
                fit: BoxFit.cover,
              ),
            ),
          ),
          // UI GAME
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
                          color: userHealth < 30 ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          "$userHealth",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      
                      // BOSS HP BAR (Custom warna Biru Es)
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
                                  // Warna HP Boss jadi Biru Muda (Es)
                                  color: Colors.lightBlueAccent, 
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                // Pastikan aset monster level 4 (Golem Es) ada
                                backgroundImage: AssetImage('assets/images/monster_level_4.png'), 
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // VISUAL STUN (Efek Beku)
                if (_isStunned)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.8), // Warna Es
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text("KAMU MEMBEKU! (STUNNED)", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),

                // ARENA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Image.asset(
                          'assets/images/mc.png',
                          height: 150,
                          fit: BoxFit.contain,
                          // Efek beku visual pada karakter
                          // color: _isStunned ? Colors.cyanAccent : null,
                          // colorBlendMode: _isStunned ? BlendMode.modulate : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Image.asset(
                          'assets/images/monster_level_4.png', // Golem Es
                          height: 180, 
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // SOAL (Kotak Biru Es)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.lightBlue, width: 2), // Border biru
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 20),
                
                // OPSI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: options.map((option) {
                      return GestureDetector(
                        onTap: () => checkAnswer(option),
                        child: Opacity(
                          opacity: _isStunned ? 0.5 : 1.0,
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: _isStunned ? Colors.cyan[100] : const Color(0xFFF0F0F0),
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
import 'dart:async'; 
import 'dart:math';  
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'level_3_page.dart'; 

class Level2Page extends StatefulWidget {
  const Level2Page({super.key});

  @override
  State<Level2Page> createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  // --- KONFIGURASI LEVEL 2 ---
  final int enemyAttackSpeedMs = 1900; 
  final int enemyDamage = 3;           
  final double userDamage = 0.2;       

  // --- STATE GAME ---
  int userHealth = 100;
  double bossHealth = 1.0; 
  Timer? _enemyAttackTimer;
  
  bool _isStunned = false; 
  bool _isHit = false; // [BARU] Variabel untuk efek hit merah

  // --- DATA SOAL ---
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

  // --- FUNGSI UPDATE LEVEL KE FIREBASE ---
  Future<void> _unlockNextLevel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot snapshot = await userDoc.get();
      int currentDbLevel = snapshot.get('level') ?? 1;

      if (currentDbLevel < 3) {
        await userDoc.update({'level': 3}); 
      }
    }
  }

  // --- LOGIKA MUSUH MENYERANG ---
  void _startEnemyAttack() {
    _enemyAttackTimer = Timer.periodic(Duration(milliseconds: enemyAttackSpeedMs), (timer) {
      if (userHealth > 0 && bossHealth > 0.05) {
        setState(() {
          userHealth -= enemyDamage;
        });

        if (userHealth <= 0) {
          userHealth = 0;
          timer.cancel();
          _showGameOverDialog(); // [BARU] Menggunakan dialog custom
        }
      }
    });
  }

  // --- LOGIKA SOAL ---
  void _generateQuestion() {
    Random random = Random();
    int operator = random.nextInt(4); 
    int a, b;

    switch (operator) {
      case 0: // Penjumlahan
        a = random.nextInt(20) + 10; 
        b = random.nextInt(20) + 10;
        question = "$a + $b";
        correctAnswer = a + b;
        break;
      case 1: // Pengurangan
        a = random.nextInt(30) + 20;
        b = random.nextInt(15) + 5; 
        question = "$a - $b";
        correctAnswer = a - b;
        break;
      case 2: // Perkalian
        a = random.nextInt(8) + 2;
        b = random.nextInt(5) + 2;
        question = "$a × $b";
        correctAnswer = a * b;
        break;
      case 3: // Pembagian
        b = random.nextInt(5) + 2; 
        int result = random.nextInt(8) + 2; 
        a = b * result; 
        question = "$a : $b";
        correctAnswer = result;
        break;
      default:
        a = 1; b = 1; question = "1+1"; correctAnswer = 2;
    }

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
    if (_isStunned) return; 

    if (selectedAnswer == correctAnswer) {
      // BENAR
      setState(() {
        bossHealth -= userDamage; 
        _isHit = true; // [BARU] Nyalakan efek merah
      });
      
      // [BARU] Matikan efek merah setelah 150ms
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _isHit = false;
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Serangan Telak!"), 
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ),
      );

      if (bossHealth <= 0.05) { 
        bossHealth = 0;
        _enemyAttackTimer?.cancel();
        _showWinDialog(); 
      } else {
        _generateQuestion(); 
      }

    } else {
      // SALAH
      setState(() {
        _isStunned = true; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salah! Terkena Stun!"), 
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1000),
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

  // --- DIALOG GAME OVER (CUSTOM STYLE DARI LEVEL 1) ---
  // [BARU] Menggantikan AlertDialog biasa
  void _showGameOverDialog() {
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
              // 1. KOTAK KONTEN PUTIH
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
                    // JUDUL MERAH
                    const Text(
                      "GAME OVER",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, 
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 10),
                    
                    // PESAN KEKALAHAN
                    const Text(
                      "Yah... HP kamu habis!\nMonster Level 2 terlalu kuat, ayo coba lagi!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // TOMBOL AKSI (Keluar & Retry)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // TOMBOL KELUAR
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // Tutup Dialog
                            Navigator.pop(context); // Kembali ke Peta
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50], 
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, color: Colors.red, size: 32),
                              ),
                              const SizedBox(height: 8),
                              const Text("Keluar", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),

                        // TOMBOL COBA LAGI (RETRY)
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Reset Game Logic
                            setState(() {
                              userHealth = 100;
                              bossHealth = 1.0;
                              _isStunned = false;
                              _isHit = false; // Reset efek visual
                              _generateQuestion();
                              _startEnemyAttack();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50], 
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.refresh_rounded, color: Colors.blue, size: 32),
                              ),
                              const SizedBox(height: 8),
                              const Text("Coba Lagi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. ICON KEPALA DI ATAS
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.red[100], 
                    child: const Icon(
                      Icons.sentiment_very_dissatisfied_rounded, 
                      color: Colors.red, 
                      size: 40
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIN DIALOG ---
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
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    const Text(
                      "LEVEL 2 SELESAI!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 10),
                    const Text("Luar biasa! Kamu semakin hebat!", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, color: Colors.amber, size: 36),
                          SizedBox(width: 8),
                          Text("10", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), 
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // TOMBOL PETA
                        InkWell(
                          onTap: () async {
                            await _unlockNextLevel();
                            if (!context.mounted) return;
                            Navigator.pop(context); 
                            Navigator.pop(context); 
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
                        // TOMBOL NEXT (LEVEL 3)
                        InkWell(
                          onTap: () async {
                            await _unlockNextLevel();
                            if (!context.mounted) return;
                            Navigator.pop(context); 
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Level3Page()));
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                                child: Icon(Icons.skip_next_rounded, color: Colors.green[700], size: 30),
                              ),
                              const SizedBox(height: 4),
                              const Text("Level 3", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
          // 1. BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hutan.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. UI UTAMA
          SafeArea(
            child: Column(
              children: [
                // HEADER
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
                      // HP User
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
                                  color: Colors.orangeAccent, 
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/monster_level_2.png'), 
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // STUN ALERT
                if (_isStunned)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Text("TERSTUN! TUNGGU SEBENTAR...", 
                      style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
                  ),

                // ARENA KARAKTER
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
                          color: _isStunned ? Colors.grey : null,
                          colorBlendMode: _isStunned ? BlendMode.saturation : null,
                        ),
                      ),
                      const SizedBox(width: 10), 
                      // MUSUH LEVEL 2
                      Flexible(
                        child: Image.asset(
                          'assets/images/monster_level_2.png', 
                          height: 190, 
                          fit: BoxFit.contain,
                          // [BARU] Logika warna merah saat kena hit
                          color: _isHit ? Colors.red : null,
                          colorBlendMode: _isHit ? BlendMode.modulate : null,
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
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5)),
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
                        child: Opacity(
                          opacity: _isStunned ? 0.5 : 1.0, 
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: _isStunned ? Colors.grey[400] : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 4))],
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
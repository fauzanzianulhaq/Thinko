import 'dart:async'; // Timer
import 'dart:math';  // Random
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Wajib untuk fix navigasi
import 'level_13_page.dart'; // Menuju Boss Region 2 (Level 13)

class Level12Page extends StatefulWidget {
  const Level12Page({super.key});

  @override
  State<Level12Page> createState() => _Level12PageState();
}

class _Level12PageState extends State<Level12Page> {
  // --- KONFIGURASI LEVEL 12 (REGION 2: GURUN) ---
  // Musuh: Sand Mummy (Mumi Pasir Kecil)
  // Karakteristik: Penjaga makam sebelum boss
  final int enemyAttackSpeedMs = 1100; // Serangan agak cepat (1.1 detik)
  final int enemyDamage = 13;          // Damage magis lumayan
  final double userDamage = 0.15;      // Butuh ~7x benar

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

  // --- LOGIKA SOAL (Level 12: Pemanasan Boss - Soal Menjebak) ---
  void _generateQuestion() {
    Random random = Random();
    int type = random.nextInt(3); 
    int a, b, c;

    if (type == 0) {
      // Prioritas Perkalian di Belakang
      // A - B x C  (Harus BxC dulu)
      a = random.nextInt(50) + 50; // Angka besar (50-99)
      b = random.nextInt(5) + 2; 
      c = random.nextInt(5) + 2;
      
      question = "$a - $b × $c";
      correctAnswer = a - (b * c);

    } else if (type == 1) {
      // Pembagian di Awal lalu Ditambah
      // A : B + C
      b = random.nextInt(8) + 2;        // Pembagi
      int hasilBagi = random.nextInt(10) + 2; 
      a = b * hasilBagi;                // A kelipatan B
      c = random.nextInt(20) + 10;
      
      question = "$a : $b + $c";
      correctAnswer = hasilBagi + c;

    } else {
      // Tanda Kurung di Belakang (Pengurangan)
      // A - (B - C) -> Ingat minus ketemu minus jadi plus, tapi di sini hasil B-C positif
      a = random.nextInt(30) + 20;
      b = random.nextInt(15) + 5;
      c = random.nextInt(b - 2) + 1; // C < B agar dalam kurung positif
      
      question = "$a - ($b - $c)";
      correctAnswer = a - (b - c);
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
          content: Text("Sihir Mumi terpental!"), 
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
      // SALAH -> Kena Stun (Kutukan Mumi)
      setState(() {
        _isStunned = true; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Awas! Kutukan Mumi (Stun)!"), 
          backgroundColor: Colors.orangeAccent, 
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
        title: const Text("Game Over! 🤕", style: TextStyle(color: Colors.brown)),
        content: const Text("Kamu terkena kutukan Mumi Pasir!"),
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
                      "Luar biasa! Mumi Pasir kembali tidur!",
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
                          Text("40", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                        // Tombol Stage Berikutnya (Ke BOSS Level 13)
                        InkWell(
                          onTap: () {
                             Navigator.pop(context); 
                             Navigator.pushReplacement(
                               context, 
                               MaterialPageRoute(builder: (context) => const Level13Page())
                             );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle), // Merah tanda Boss
                                child: Icon(Icons.warning_rounded, color: Colors.red[800], size: 30),
                              ),
                              const SizedBox(height: 4),
                              const Text("BOSS FIGHT!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
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
          // 1. BACKGROUND (Gurun - Region 2)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/region_2/gurun.png'), 
                fit: BoxFit.cover, 
              ),
            ),
          ),

          // 2. TAMPILAN UI
          SafeArea(
            child: Column(
              children: [
                // --- HEADER: HP BAR ---
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
                      // HP User Badge
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

                      // HP Boss Bar (Kanan)
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
                            // Isi Darah (Kuning Emas - Mumi)
                            FractionallySizedBox(
                              widthFactor: bossHealth > 0 ? bossHealth : 0, 
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.amber[700], // Warna Emas Mumi
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // Icon Monster Kecil
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                // Pastikan ini path ke gambar monster Sand Mummy
                                backgroundImage: AssetImage('assets/region_2/monster_lvl_12.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // VISUAL STUN (Efek Kutukan)
                if (_isStunned)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.8), // Warna Sihir Pasir
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text("KUTUKAN MUMI! (STUNNED)", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),

                // --- ARENA KARAKTER ---
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
                          height: 150, 
                          fit: BoxFit.contain, 
                          // color: _isStunned ? Colors.orange[200] : null, // Efek pasir
                          // colorBlendMode: _isStunned ? BlendMode.modulate : null,
                        ),
                      ),
                      
                      const SizedBox(width: 10), 

                      // MUSUH (Kanan - Monster Level 12 Sand Mummy)
                      Flexible(
                        child: Image.asset(
                          'assets/region_2/monster_lvl_12.png', 
                          height: 170, 
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
                    border: Border.all(color: Colors.amber[800]!, width: 2), // Border emas
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                  ),
                  child: Text(
                    question, 
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
                        child: Opacity(
                          opacity: _isStunned ? 0.5 : 1.0,
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: _isStunned ? Colors.amber[100] : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 4))
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
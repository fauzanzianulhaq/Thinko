import 'dart:async'; // Timer
import 'dart:math';  // Random
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Wajib untuk fix navigasi
// import 'level_14_page.dart'; // Uncomment jika sudah masuk Region 3

class Level13Page extends StatefulWidget {
  const Level13Page({super.key});

  @override
  State<Level13Page> createState() => _Level13PageState();
}

class _Level13PageState extends State<Level13Page> {
  // --- KONFIGURASI LEVEL 13 (BOSS REGION 2: ANCIENT SPHINX) ---
  // Difficulty: VERY HARD
  final int enemyAttackSpeedMs = 1500; // Serangan lambat (1.5 detik) tapi...
  final int enemyDamage = 15;          // DAMAGENYA SAKIT (Sekali kena -15 HP)
  final double userDamage = 0.08;      // Boss SANGAT TEBAL (Butuh ~13x benar)
  
  // HP Karakter DIBATASI (Maksimal 50) - HARD MODE
  final int maxUserHealth = 50; 

  // --- STATE GAME ---
  late int userHealth; 
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
    userHealth = maxUserHealth; // Set HP awal ke 50 (Tantangan Boss)
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

  // --- LOGIKA SOAL (Level 13: UJIAN AKHIR - SOAL SPHINX) ---
  // Soal kompleks dengan 3-4 angka dan operasi campuran
  void _generateQuestion() {
    Random random = Random();
    int type = random.nextInt(3); // 3 Variasi Soal Boss
    int a, b, c, d;

    if (type == 0) {
      // Variasi 1: Perkalian, Tambah, Kurang (Prioritas Perkalian)
      // A x B + C - D
      a = random.nextInt(8) + 3;   // 3-10
      b = random.nextInt(8) + 3;   // 3-10
      c = random.nextInt(20) + 10; // 10-29
      d = random.nextInt(15) + 5;  // 5-19
      
      question = "$a × $b + $c - $d";
      correctAnswer = (a * b) + c - d;

    } else if (type == 1) {
      // Variasi 2: Pembagian lalu Pengurangan (Hati-hati)
      // (A : B) - C
      b = random.nextInt(6) + 3;        // Pembagi 3-8
      int hasilBagi = random.nextInt(15) + 10; // Hasil bagi besar (10-24)
      a = b * hasilBagi;                // A kelipatan B (30-192)
      c = random.nextInt(hasilBagi - 5) + 1; // Pengurang < Hasil Bagi
      
      question = "$a : $b - $c";
      correctAnswer = (a ~/ b) - c;

    } else {
      // Variasi 3: Pengurangan Beruntun & Penjumlahan (Butuh Fokus)
      // A - B + C - D
      a = random.nextInt(50) + 50; // Angka awal besar (50-99)
      b = random.nextInt(20) + 10; 
      c = random.nextInt(20) + 10;
      d = random.nextInt(20) + 5;
      
      question = "$a - $b + $c - $d";
      correctAnswer = a - b + c - d;
    }

    // Generate Opsi Jawaban (Opsinya SANGAT MENJEBAK - Berdekatan)
    Set<int> optionsSet = {correctAnswer};
    while (optionsSet.length < 4) {
      // Offset sangat kecil (1-3) agar jawaban mirip-mirip dan membingungkan
      int offset = random.nextInt(3) + 1; 
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
          content: Text("TEPAT! Sphinx meraung kesakitan!"), 
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
      // SALAH -> Kena Stun + Hukuman HP (HARD MODE)
      setState(() {
        _isStunned = true; 
        // Hukuman HP berkurang juga kalau salah jawab!
        userHealth -= 5;
        if (userHealth < 0) userHealth = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("SALAH! Kamu membatu! (-5 HP)"), 
          backgroundColor: Colors.grey, // Warna Batu
          duration: Duration(milliseconds: 500),
        ),
      );

      // Cek Mati karena salah jawab
      if (userHealth <= 0) {
         _enemyAttackTimer?.cancel();
         _showGameOverDialog();
         return;
      }

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
        title: const Text("Game Over! 🗿", style: TextStyle(color: Colors.grey)),
        content: const Text("Sphinx telah menjadikanmu patung pasir selamanya..."),
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
                userHealth = maxUserHealth; // Reset ke 50
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
                      "REGION 2 SELESAI !",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 10),
                    
                    const Text(
                      "Luar Biasa! Sphinx Kuno tunduk padamu!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Bintang & Skor (Bonus Besar Boss)
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
                          Text("100", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                        // Tombol NEXT REGION (Region 3)
                        InkWell(
                          onTap: () {
                             Navigator.pop(context); 
                             // Uncomment jika sudah ada Region 3
                             // Navigator.pushReplacement(
                             //   context, 
                             //   MaterialPageRoute(builder: (context) => const Level14Page())
                             // );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
                                child: Icon(Icons.public, color: Colors.blue[800], size: 30), // Icon Globe Baru
                              ),
                              const SizedBox(height: 4),
                              const Text("Region Baru", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                      // HP User Badge (MERAH KARENA HP MAKS CUMA 50)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[700], // Merah tanda bahaya
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          "$userHealth / $maxUserHealth", // Tampilkan per 50
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
                            // Isi Darah (Emas Gelap - Sphinx)
                            FractionallySizedBox(
                              widthFactor: bossHealth > 0 ? bossHealth : 0, 
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.amber[900], // Warna Emas Tua
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // Icon Boss Besar
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 20, // Agak besar karena Boss
                                backgroundColor: Colors.white,
                                // Pastikan ini path ke gambar Sphinx
                                backgroundImage: AssetImage('assets/region_2/monster_lvl_13.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // VISUAL STUN (Efek Membatu)
                if (_isStunned)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.9), // Warna Batu
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text("TUBUHMU MEMBATU! (STUNNED)", 
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
                          color: _isStunned ? Colors.grey : null, // Jadi abu-abu batu
                          colorBlendMode: _isStunned ? BlendMode.saturation : null,
                        ),
                      ),
                      
                      const SizedBox(width: 10), 

                      // BOSS SPHINX (Kanan)
                      Flexible(
                        child: Image.asset(
                          'assets/region_2/monster_lvl_13.png', 
                          height: 220, // Boss SANGAT BESAR
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- KOTAK SOAL (Emas Mewah) ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber[900]!, width: 3), // Border Emas Tebal
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
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
                              color: _isStunned ? Colors.grey[400] : const Color(0xFFF0F0F0),
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
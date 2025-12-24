import 'package:flutter/material.dart';
import 'registration_success_page.dart';

class PinConfirmationPage extends StatefulWidget {
  // Kita butuh data PIN dari halaman sebelumnya untuk dicocokkan
  final String sourcePin;

  const PinConfirmationPage({super.key, required this.sourcePin});

  @override
  State<PinConfirmationPage> createState() => _PinConfirmationPageState();
}

class _PinConfirmationPageState extends State<PinConfirmationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isPinVisible = false; // Default tersembunyi biar aman

  @override
  void dispose() {
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
              Color(0xFFD0F8CE),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Header: Tombol Kembali
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

              // Progress Bar (Tetap sama seperti langkah sebelumnya sesuai desain)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
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
                      
                      Image.asset(
                        'assets/images/logo_thinko2.png',
                        height: 120,
                      ),
                      
                      const SizedBox(height: 20),

                      // Judul yang berbeda dari halaman sebelumnya
                      const Text(
                        'Sekarang tulis ulang PIN\nmu tadi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Input PIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 70,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              obscureText: !_isPinVisible,
                              obscuringCharacter: '●',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: "", 
                              ),
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Toggle Visibility
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPinVisible = !_isPinVisible;
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

              // Tombol "Selesai"
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
            String confirmPin = _controllers.map((c) => c.text).join();
  
                if (confirmPin == widget.sourcePin) {
              // SUKSES: PIN COCOK -> Pindah ke Halaman Sukses
              Navigator.push(
          context,
      MaterialPageRoute(
        builder: (context) => const RegistrationSuccessPage(),
      ),
         );
             } else {
          // GAGAL
           ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
           content: Text('Ups, PIN tidak sama. Coba lagi ya.'),
            backgroundColor: Colors.red,
                ),
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
                      'Selesai',
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
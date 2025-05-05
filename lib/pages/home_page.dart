import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Ungu
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.45,
              decoration: const BoxDecoration(color: Color(0xFF7E1AD1)),
            ),
          ),

          // Komponen lain di atas background ungu
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ), // untuk space atas (status bar + padding)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello, John!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome Back To DoKo',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.topCenter, // Bisa juga alignment lain
                  child: Container(
                    width: 360,
                    height: 341,
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.03, // 3% dari tinggi layar
                      left: screenWidth * 0.05, // 5% dari lebar layar (kiri)
                      right: screenWidth * 0.05, // 5% dari lebar layar (kanan)
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text("Komponen lainnya di sini"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

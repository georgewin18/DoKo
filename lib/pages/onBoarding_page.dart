import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:app/components/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/components/onboarding_content.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Mulai Sekarang',
      onFinish: () => _completeOnboarding(context),
      finishButtonStyle: const FinishButtonStyle(
        backgroundColor: Color(0xFF8B5CF6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      skipTextButton: const Text(
        'Lewati',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF8B5CF6),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: const Text(
        'Lewati',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF8B5CF6),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      trailingFunction: () => _completeOnboarding(context),
      controllerColor: const Color(0xFF8B5CF6),
      totalPage: 6,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        // Background untuk slide 1
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Background untuk slide 2
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Background untuk slide 3
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        // Background untuk slide 4
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9333EA), Color(0xFF8B5CF6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Background untuk slide 5
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Background untuk slide 6
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
      speed: 1.8,
      pageBodies: [
        OnboardingContent(
          imagePath: 'assets/images/onboarding_welcome.png',
          title: 'Selamat Datang di Doko',
          description:
              'Aplikasi manajemen tugas terbaik untuk meningkatkan produktivitas Anda setiap hari.',
        ),
        OnboardingContent(
          imagePath: 'assets/images/onboarding_calendar.png',
          title: 'Kalender Interaktif',
          description:
              'Klik pada tanggal di kalender untuk melihat tugas spesifik hari tersebut. Kelola jadwal Anda dengan mudah.',
        ),
        OnboardingContent(
          imagePath: 'assets/images/onboarding_tasks.png',
          title: 'Manajemen Tugas',
          description:
              'Tambah, edit, dan hapus tugas dengan mudah. Atur prioritas dan pantau progress Anda setiap hari.',
        ),
        OnboardingContent(
          imagePath: 'assets/images/onboarding_notifications.png',
          title: 'Notifikasi & Pengingat',
          description:
              'Dapatkan notifikasi untuk tugas penting dan jangan pernah melewatkan deadline lagi.',
        ),
        OnboardingContent(
          imagePath: 'assets/images/onboarding_start.png',
          title: 'Siap Memulai?',
          description:
              'Mulai perjalanan produktivitas Anda bersama Doko. Atur tugas, capai tujuan, dan tingkatkan efisiensi!',
        ),
        OnboardingContent(
          imagePath: 'assets/images/onboarding_start.png',
          title: 'Siap Memulai?',
          description:
              'Mulai perjalanan produktivitas Anda bersama Doko. Atur tugas, capai tujuan, dan tingkatkan efisiensi!',
        ),
      ],
    );
  }
}

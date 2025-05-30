import 'package:app/constants/app_string.dart';
import 'package:app/db/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:app/components/bottom_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize NotificationService dengan error handling
  bool notificationInitialized = false;
  try {
    debugPrint('Initializing NotificationService...');
    await NotificationService().initialize();
    debugPrint('NotificationService initialized successfully');
    notificationInitialized = true;
    
  } catch (e, stackTrace) {
    debugPrint('Error initializing NotificationService: $e');
    debugPrint('Stack trace: $stackTrace');
    // App tetap bisa jalan meskipun notification gagal
  }
  
  // Reschedule notifications hanya jika initialization berhasil
  if (notificationInitialized) {
    try {
      debugPrint('Rescheduling pending notifications...');
      await NotificationService().rescheduleAllNotification();
      debugPrint('Pending notifications rescheduled');
      
      // Cleanup old notifications
      await NotificationService().cleanupOldNotifications();
      debugPrint('Old notifications cleaned up');
      
    } catch (e, stackTrace) {
      debugPrint('Error rescheduling notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true, 
        fontFamily: "Poppins",
        // Tambahan theme untuk notification
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const BottomNavBar(),
      // Tambahan untuk debug
      debugShowCheckedModeBanner: false,
    );
  }
}
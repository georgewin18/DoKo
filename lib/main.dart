import 'package:app/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/user_preferences.dart';
import 'package:app/db/notification_helper.dart';
import 'package:app/components/bottom_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userPrefs = UserPreferences();
  await userPrefs.load();
  await initializeDateFormatting('id_ID', null);

  await NotificationHelper.initialize();

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

  runApp(
    ChangeNotifierProvider(create: (_) => userPrefs, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doko",
      theme: ThemeData(useMaterial3: true, fontFamily: "Poppins"),
      home: const SplashScreen(),
    );
  }
}

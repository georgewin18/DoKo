import 'package:flutter/material.dart';
import 'package:app/components/bottom_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await initializeDateFormatting('id_ID', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
}  

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doko',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      // home: const MyHomePage(title: 'Doko'),
      home: const BottomNavBar(),
    );
  }
}

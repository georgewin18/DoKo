import 'package:doko/models/task_group_model.dart';
import 'package:doko/pages/add_group_page.dart';
import 'package:doko/pages/home_page.dart';
import 'package:doko/pages/task_group_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:doko/components/calendar.dart';
import 'package:doko/components/bottom_navigation_bar.dart';
import 'package:doko/pages/add_task.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:doko/pages/detail_group_page.dart';

void main() async {
  sqfliteFfiInit();    
  databaseFactory = databaseFactoryFfi;      
  WidgetsFlutterBinding.ensureInitialized();  
  await initializeDateFormatting('id_ID', null);
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

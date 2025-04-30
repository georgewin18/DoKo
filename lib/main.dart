import 'package:doko/components/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // untuk inisialisasi tanggalan
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MaterialApp(
      home: Scaffold(body: Center(child: Calendar(isHomepage: false))),
    ),
  );
}

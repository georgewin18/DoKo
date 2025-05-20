import 'package:flutter/material.dart';

enum TaskPriority { normal, priority }

enum TaskStatus {
  overdue, // Red - statusColor[0]
  ongoing, // Brown - statusColor[1]
  notStarted, // Gray - statusColor[2]
  dueToday, // Yellow - statusColor[3]
  completed, // Green - statusColor[4]
  event, // Blue - statusColor[5]
  priority, // Purple - statusColor[6]
}

const themeColors = [
  Color(0xffFF5555),
  Color(0xff663300),
  Color(0xff404040),
  Color(0xffFA7D00),
  Color(0xff199328),
  Color(0xff2851C6),
  Color(0xff7E1AD1),
];

const statusColor = [
  Color(0xffD60000),
  Color(0xffAF6E4D),
  Color(0xFF9C9C9C),
  Color(0xffFFC000),
  Color(0xff2BE13C),
  Color(0xFF26B5FD),
  Color(0xffBE28BE),
];

Color white = Color(0xFFFFFFFF); //buat foreground / tulisan
Color gray1 = Color(0xFFC0C0C0); //buat hint text
Color gray2 = Color(0xFF7F7F7F); //buat box shadow
Color gray3 = Color(0xFF3F3F3F); //buat title
Color black = Color(0xFF000000); //buat tulisan
Color transparent = Colors.transparent;

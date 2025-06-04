import 'package:flutter/material.dart';

/*
untuk masalah color mengikuti preferensi user jika user
memilih violet (defaultnya violet) maka ia (colorPreference) akan
di set violet.
*/

/*
jangan gunakan list color ini secara literal 
gunakan colorPreference dari user
*/

const List<Color> violet = [
  Color(0xff30074f), //0 untuk gradasi gelap navbar
  Color(0xff4d107f), //1 untuk navbar dan counter di group
  Color(0xff7E1AD1), //2 untuk appbar, calendar, dan judul group
  Color(0xffb877f0), //3 untuk gradasi appbar, dan warna description
];

const List<Color> grass = [
  Color(0xff236e0e),
  Color(0xff1c8720),
  Color(0xff35a017),
  Color(0xFF6BEA66),
];

const List<Color> rose = [
  Color(0xffff0000),
  Color(0xffff5555),
  Color(0xffff8080),
  Color(0xffffb3b3),
];

const List<Color> ocean = [
  Color(0xff2851c6),
  Color(0xff3f72e0),
  Color(0xff0f9cf8),
  Color(0xff63cbff),
];

const List<Color> amber = [
  Color(0xfffa7d00),
  Color(0xffffb333),
  Color(0xffffd34d),
  Color(0xffffee99),
];

const List<Color> wood = [
  Color(0xff663300),
  Color(0xff8a4a2d),
  Color(0xffaf6e4d),
  Color(0xffdfa57d),
];

const List<Color> metal = [
  Color(0xff404040),
  Color(0xff5e5e5e),
  Color(0xff757575),
  Color(0xff9c9c9c),
];

/*
Ini untuk warna button sesuai pesan 
yang ingin disampaikan
*/
const Color danger = Color(0xffDC3545);
const Color warning = Color(0xffFFC107);
const Color success = Color(0xff2ECC71);

/*
Ini default pallete untuk lightmode dan darkmode
*/
const Color white = Color(0xFFFFFFFF); //buat foreground / tulisan
const Color gray1 = Color(0xFFC0C0C0); //buat hint text
const Color gray2 = Color(0xFF7F7F7F); //buat box shadow
const Color gray3 = Color(0xFF3F3F3F); //buat title
const Color black = Color(0xFF000000); //buat tulisan
const Color transparent = Colors.transparent;

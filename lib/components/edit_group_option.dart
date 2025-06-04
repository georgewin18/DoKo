import 'package:app/constants/app_string.dart';
import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

Future<String?> editGroupOption(
  BuildContext context,
  TapDownDetails details,
  RenderBox overlay,
) {
  final appString = AppString(context);
  return showMenu(
    context: context,
    color: white,
    position: RelativeRect.fromRect(
      details.globalPosition & const Size(40, 40), // posisi titik klik
      Offset.zero & overlay.size, // ukuran layar
    ),
    items: [
      PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit_outlined, color: Color(0xFF7E1AD1)),
            const SizedBox(width: 10),
            Text(appString.editGroupTitle),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 10),
            Text(appString.deleteGroupTitle),
          ],
        ),
      ),
    ],
  );
}

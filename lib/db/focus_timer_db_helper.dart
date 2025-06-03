import 'package:app/models/focus_timer_model.dart';
import 'db_provider.dart';

class FocusTimerDbHelper {
  static const String _tableName = 'focus_timer';

  static Future<int> addFocusTimer(FocusTimer focusTimer) async {
    final db = await DBProvider.database;
    return await db.insert(_tableName, focusTimer.toMap());
  }

  static Future<List<FocusTimer>> getFocusTimer({String? orderBy}) async {
    final db = await DBProvider.database;
    final maps = await db.query(_tableName, orderBy: orderBy);
    return List.generate(maps.length, (i) => FocusTimer.fromMap(maps[i]));
  }

  static Future<int> updateFocusTimer(FocusTimer focusTimer) async {
    final db = await DBProvider.database;
    return await db.update(
      _tableName,
      focusTimer.toMap(),
      where: 'id = ?',
      whereArgs: [focusTimer.id],
    );
  }

  Future<int> deleteFocusTimer(int? id) async {
    final db = await DBProvider.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}

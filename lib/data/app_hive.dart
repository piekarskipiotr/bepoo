import 'package:hive_flutter/hive_flutter.dart';

late final Box<dynamic> poostsBox;

class AppHive {
  static Future<void> init() async {
    await Hive.initFlutter();
    await _registerAdapters();
    await openBoxes();
  }
}

Future<void> openBoxes() async {
  poostsBox = await Hive.openBox('poosts_box');
}

Future<void> _registerAdapters() async {}

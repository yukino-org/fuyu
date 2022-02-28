import 'dart:io';
import 'package:path/path.dart' as path;

abstract class Paths {
  static final String cwd = Directory.current.path;
  static late final String data = path.join(cwd, '.data');
  static late final String chromium = path.join(data, 'chromium');
  static late final String tenka = path.join(data, 'tenka');
}

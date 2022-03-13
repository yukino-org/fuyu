import 'dart:io';
import 'package:path/path.dart' as path;

export '../src/config/meta.dart';

abstract class Paths {
  static final String rootDir = Directory.current.path;
  static final String srcDir = path.join(rootDir, 'src');
  static final String mainFilePath = path.join(srcDir, 'main.dart');
  static final String outputDir = path.join(rootDir, 'bin');
}

enum OperatingSystem {
  windows,
  linux,
  macos,
}

OperatingSystem getOperatingSystem() {
  if (Platform.isWindows) return OperatingSystem.windows;
  if (Platform.isLinux) return OperatingSystem.linux;
  if (Platform.isMacOS) return OperatingSystem.macos;
  throw Exception('Unsupported platform');
}

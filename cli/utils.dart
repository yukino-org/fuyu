import 'dart:io';
import 'package:path/path.dart' as path;

abstract class Paths {
  static final String rootDir = Directory.current.path;
  static final String srcDir = path.join(rootDir, 'src');
  static final String mainFilePath = path.join(srcDir, 'main.dart');
  static final String outputDir = path.join(rootDir, 'bin');
}

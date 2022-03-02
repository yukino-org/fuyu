// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as path;
import 'utils.dart';

final String pubspecPath = path.join(Paths.rootDir, 'pubspec.yaml');
final String metaPath = path.join(Paths.srcDir, 'config/meta.g.dart');

Future<void> main() async {
  final String pubspec = await File(pubspecPath).readAsString();

  final String version =
      RegExp(r'version: ([\w-.]+)').firstMatch(pubspec)!.group(1)!;

  final String content = '''
part of 'meta.dart';

abstract class _GeneratedAppMeta {
  static const String version = '$version';
}'''
      .trim();

  print(
    '''
```
$content
```
  '''
        .trim(),
  );

  await File(metaPath).writeAsString(content);

  print('\nGenerated $metaPath');
}

part 'meta.g.dart';

abstract class AppMeta {
  static const String name = 'Fuyu';
  static const String version = _GeneratedAppMeta.version;
  static const String github = 'https://github.com/yukino-org/fuyu';

  static String get id => name.toLowerCase();
}

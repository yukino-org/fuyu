// ignore_for_file: avoid_print

import '../core/app.dart';

abstract class Logger {
  static void info(final String text) {
    _print('[$time INFO] $text');
  }

  static void debug(final String text) {
    _print('[$time DBUG] $text');
  }

  static void warn(final String text) {
    _print('[$time WARN] $text');
  }

  static void error(final String text) {
    _print('[$time ERR!] $text');
  }

  static void _print(final String text) {
    if (!(AppManager.argResults['suppress'] as bool)) {
      print(text);
    }
  }

  static String get time {
    final DateTime now = DateTime.now();
    return <String>[
      now.hour.toString().padLeft(2, '0'),
      now.minute.toString().padLeft(2, '0'),
      now.second.toString().padLeft(2, '0'),
    ].join(':');
  }
}

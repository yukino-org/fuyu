// ignore_for_file: avoid_print

abstract class Logger {
  static void info(final String text) {
    print('[$time INFO] $text');
  }

  static void debug(final String text) {
    print('[$time DBUG] $text');
  }

  static void error(final String text) {
    print('[$time ERR!] $text');
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

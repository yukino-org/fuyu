import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'router.dart';
import 'tenka.dart';

class ServerAddress {
  const ServerAddress(this.protocol, this.host, this.port);

  final String protocol;
  final String host;
  final int port;

  String get url => '$protocol://$host:$port';
  Uri get uri => Uri.parse(url);
}

abstract class AppManager {
  static bool initialized = false;
  static bool disposed = false;

  static late ArgResults argResults;
  static late ServerAddress address;
  static late HttpServer server;
  static late RouteManager router;

  static StreamSubscription<ProcessSignal>? sigintSubscription;
  static final List<Future<void>> pendingCriticals = <Future<void>>[];

  static Future<void> initialize() async {
    if (initialized) return;
    initialized = true;

    sigintSubscription =
        ProcessSignal.sigint.watch().listen((final ProcessSignal _) {
      pendingCriticals.add(quit());
    });

    await TenkaManager.initialize();
  }

  static Future<void> dispose() async {
    if (disposed) return;
    disposed = true;

    await TenkaManager.dispose();
  }

  static Future<void> quit() async {
    await dispose();
    await sigintSubscription?.cancel();
    sigintSubscription = null;
    await waitForCriticals();
    exit(exitCode);
  }

  static Future<void> waitForCriticals() async {
    await Future.wait(pendingCriticals);
  }
}

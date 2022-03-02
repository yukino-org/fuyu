import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'core/app.dart';
import 'core/args.dart';
import 'core/router.dart';
import 'tools/logger.dart';

Future<void> main(final List<String> args) async {
  AppManager.argResults = argParser.parse(args);
  await AppManager.initialize();
  Logger.debug('main: Initialized AppManager');

  final InternetAddress host =
      InternetAddress(AppManager.argResults['host'] as String);
  Logger.debug('main: host - ${host.host}');

  final int port = int.parse(AppManager.argResults['port'] as String);
  Logger.debug('main: port - $port');

  AppManager.router = await RouteManager.createRouter();
  Logger.debug('main: Created router');

  final Handler handler = const Pipeline().addMiddleware(
    logRequests(
      logger: (final String message, final bool isError) {
        final String parsed = RegExp(r'[\dT:\-\.]+\s+[\dT:\-\.]+\s+(.*)')
            .firstMatch(message)!
            .group(1)!;

        if (isError) {
          Logger.error('request: $parsed');
        } else {
          Logger.debug('request: $parsed');
        }
      },
    ),
  ).addHandler(AppManager.router.router);
  Logger.debug('main: Prepared handler');

  if (AppManager.argResults['listen'] as bool) {
    AppManager.server = await serve(handler, host, port);
    Logger.debug('main: Started server');

    Logger.info(
      'server: Serving at http://${AppManager.server.address.host}:${AppManager.server.port}/',
    );
  } else {
    Logger.warn(
      'server: On mock mode due to --no-listen flag',
    );
  }
}

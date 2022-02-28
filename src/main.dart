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

  final InternetAddress host =
      InternetAddress(AppManager.argResults['host'] as String);

  final int port = int.parse(AppManager.argResults['port'] as String);

  final Router router = await RouteManager.createRouter();

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
  ).addHandler(router);

  final HttpServer server = await serve(handler, host, port);

  Logger.info(
    'server: Listening on port http://${server.address.address}:${server.port}',
  );
}

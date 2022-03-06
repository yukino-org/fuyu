import 'package:shelf/shelf.dart';
import '../core/router.dart';
import '../tools/data/favicon.dart';
import '../tools/docs/api.dart';
import '../tools/http.dart';

final RouteFactory favicon =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  router.get(
    '/favicon.png',
    (final Request request) async => Response.ok(
      faviconData,
      headers: getDefaultHeaders(
        contentType: ContentType.png,
      ),
    ),
  );
});

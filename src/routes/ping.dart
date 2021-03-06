import 'package:shelf/shelf.dart';
import '../core/router.dart';
import '../tools/docs/api.dart';
import '../tools/http.dart';
import '../tools/response.dart';

final RouteFactory ping =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  router.get(
    '/ping',
    (final Request request) async => Response.ok(
      JsonResponse.success(null),
      headers: getDefaultHeaders(
        contentType: ContentType.json,
      ),
    ),
  );
});

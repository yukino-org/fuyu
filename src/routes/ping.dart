import 'package:shelf/shelf.dart';
import '../core/router.dart';
import '../tools/response.dart';

final RouteFactory ping = createRouteFactory((final Router router) async {
  router.get(
    '/ping',
    (final Request request) async => Response.ok(JsonResponse.success(null)),
  );
});

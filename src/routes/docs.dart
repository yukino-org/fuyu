import 'package:shelf/shelf.dart';
import '../core/app.dart';
import '../core/router.dart';
import '../tools/docs/api.dart';
import '../tools/docs/html.dart';
import '../tools/http.dart';

final RouteFactory docs =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  if (AppManager.argResults['docs'] as bool) {
    router.get(
      '/docs',
      (final Request request) async => Response.ok(
        getHtmlDocumentation(docs),
        headers: getDefaultHeaders(
          contentType: ContentType.html,
        ),
      ),
    );
  }
});

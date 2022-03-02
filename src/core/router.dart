import 'package:shelf_router/shelf_router.dart';
import '../routes/_handlers/not_found.dart';
import '../routes/anime/info.dart';
import '../routes/anime/search.dart';
import '../routes/anime/sources.dart';
import '../routes/docs.dart';
import '../routes/manga/chapter.dart';
import '../routes/manga/info.dart';
import '../routes/manga/page.dart';
import '../routes/manga/search.dart';
import '../routes/ping.dart';
import '../tools/docs/api.dart';

export 'package:shelf_router/shelf_router.dart';

typedef RouteFactory = Future<void> Function(Router, ApiDocs);

RouteFactory createRouteFactory(final RouteFactory f) => f;

class RouteManager {
  const RouteManager({
    required this.router,
    required this.apiDocs,
  });

  final Router router;
  final ApiDocs apiDocs;

  static final List<RouteFactory> _factories = <RouteFactory>[
    animeSearch,
    animeInfo,
    animeSources,
    mangaSearch,
    mangaInfo,
    mangaChapter,
    mangaPage,
    docs,
    ping,
  ];

  static Future<RouteManager> createRouter() async {
    final Router router = Router(notFoundHandler: notFoundHandler);
    final ApiDocs apiDocs = ApiDocs();

    for (final RouteFactory x in _factories) {
      await x(router, apiDocs);
    }

    return RouteManager(router: router, apiDocs: apiDocs);
  }
}

import 'package:shelf_router/shelf_router.dart';
import '../routes/_handlers/not_found.dart';
import '../routes/anime/info.dart';
import '../routes/anime/search.dart';
import '../routes/anime/sources.dart';
import '../routes/manga/chapter.dart';
import '../routes/manga/info.dart';
import '../routes/manga/page.dart';
import '../routes/manga/search.dart';
import '../routes/ping.dart';

export 'package:shelf_router/shelf_router.dart';

typedef RouteFactory = Future<void> Function(Router);

RouteFactory createRouteFactory(final RouteFactory f) => f;

abstract class RouteManager {
  static final List<RouteFactory> _factories = <RouteFactory>[
    animeSearch,
    animeInfo,
    animeSources,
    mangaSearch,
    mangaInfo,
    mangaChapter,
    mangaPage,
    ping,
  ];

  static Future<Router> createRouter() async {
    final Router _router = Router(notFoundHandler: notFoundHandler);

    for (final RouteFactory x in _factories) {
      await x(_router);
    }

    return _router;
  }
}

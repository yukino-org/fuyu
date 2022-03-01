import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory mangaPage = createRouteFactory((final Router router) async {
  router.get(
    '/manga/page',
    (final Request request) async {
      final String? url = request.url.queryParameters['url'];
      if (url == null) {
        return ResponseUtils.missingQuery('url');
      }

      final dynamic parsedQuery = await TenkaQuery.parse<MangaExtractor>(
        request: request,
        type: TenkaType.manga,
      );

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<MangaExtractor> castedQuery =
          parsedQuery as TenkaQuery<MangaExtractor>;

      final String cKey = castedQuery.getCacheKey('page_$url');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final ImageDescriber result;
        final CacheData<ImageDescriber>? cached =
            Cache.get<ImageDescriber>(cKey);

        if (cached != null) {
          result = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          result = await castedQuery.extractor
              .getPage(PageInfo(url: url, locale: castedQuery.locale));
          Cache.set<ImageDescriber>(cKey, result);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(result.toJson()),
          headers: headers,
        );
      } catch (err) {
        Logger.error('response: Failed $err (${request.url}}');
        return Response.internalServerError(
          body: JsonResponse.fail('Something went wrong'),
        );
      }
    },
  );
});

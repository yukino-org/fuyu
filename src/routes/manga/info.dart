import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory mangaInfo = createRouteFactory((final Router router) async {
  router.get(
    '/manga/info',
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

      final String cKey = castedQuery.getCacheKey('info_$url');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final MangaInfo result;
        final CacheData<MangaInfo>? cached = Cache.get<MangaInfo>(cKey);

        if (cached != null) {
          result = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          result = await castedQuery.extractor.getInfo(url, castedQuery.locale);
          Cache.set<MangaInfo>(cKey, result);
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

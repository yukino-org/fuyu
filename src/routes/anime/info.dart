import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/docs/api.dart';
import '../../tools/docs/datatype.dart';
import '../../tools/docs/predefined/schemas/anime/info.dart';
import '../../tools/docs/predefined/schemas/json_response.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory animeInfo =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  docs.addRoute(
    ApiRoute(
      heading: 'Get Anime Information',
      method: ApiRouteMethod.get,
      path: '/anime/info?url={url}&${TenkaQuery.parseQuery}',
      descripton: 'Get information about an anime.',
      keys: <ApiRouteKey>[
        ApiRouteKey(
          name: 'url',
          description: 'URL of an anime.',
          datatype: SchemaDataType.string(),
        ),
        ...TenkaQuery.parseQueryKeys,
      ],
      successResponse: getJsonResponse(animeInfoSchemaDataType),
      failResponse: getFailJsonResponse(),
    ),
  );

  router.get(
    '/anime/info',
    (final Request request) async {
      final String? url = request.url.queryParameters['url'];
      if (url == null) {
        return ResponseUtils.missingQuery('url');
      }

      final dynamic parsedQuery =
          await TenkaQuery.parse<AnimeExtractor>(request);

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<AnimeExtractor> castedQuery =
          parsedQuery as TenkaQuery<AnimeExtractor>;

      final String cKey = castedQuery.getCacheKey('info_$url');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final AnimeInfo result;
        final CacheData<AnimeInfo>? cached = Cache.get<AnimeInfo>(cKey);

        if (cached != null) {
          result = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          result = await castedQuery.extractor.getInfo(url, castedQuery.locale);
          Cache.set<AnimeInfo>(cKey, result);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(result.toJson()),
          headers: headers,
        );
      } catch (err) {
        Logger.error('response: Failed $err (${request.url}}');
        return Response.internalServerError(
          body: JsonResponse.somethingWentWrong,
        );
      }
    },
  );
});

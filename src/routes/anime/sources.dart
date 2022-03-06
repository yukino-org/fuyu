import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/docs/api.dart';
import '../../tools/docs/datatype.dart';
import '../../tools/docs/predefined/schemas/anime/episode/source.dart';
import '../../tools/docs/predefined/schemas/json_response.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory animeSources =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  docs.addRoute(
    ApiRoute(
      heading: 'Get Anime Episode Sources',
      method: ApiRouteMethod.get,
      path: '/anime/sources?url={url}&${TenkaQuery.parseQuery}',
      descripton: 'Get sources of an anime episode.',
      keys: <ApiRouteKey>[
        ApiRouteKey(
          name: 'url',
          description: 'URL of an anime episode.',
          datatype: SchemaDataType.string(),
        ),
        ...TenkaQuery.parseQueryKeys,
      ],
      successResponse:
          getJsonResponse(SchemaDataType.array(episodeSourceSchemaDataType)),
      failResponse: getFailJsonResponse(),
    ),
  );

  router.get(
    '/anime/sources',
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

      final String cKey = castedQuery.getCacheKey('sources_$url');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final List<EpisodeSource> results;
        final CacheData<List<EpisodeSource>>? cached =
            Cache.get<List<EpisodeSource>>(cKey);

        if (cached != null) {
          results = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          results =
              await castedQuery.extractor.getSources(url, castedQuery.locale);
          Cache.set<List<EpisodeSource>>(cKey, results);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(
            results.map((final EpisodeSource x) => x.toJson()).toList(),
          ),
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

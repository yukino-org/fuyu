import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/docs/api.dart';
import '../../tools/docs/datatype.dart';
import '../../tools/docs/predefined/schemas/json_response.dart';
import '../../tools/docs/predefined/schemas/search/info.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory animeSearch =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  docs.addRoute(
    ApiRoute(
      heading: 'Search Anime',
      method: ApiRouteMethod.get,
      path: '/anime/search?terms={terms}&${TenkaQuery.parseQuery}',
      descripton: 'Search for an anime.',
      keys: <ApiRouteKey>[
        ApiRouteKey(
          name: 'terms',
          description: 'Search terms to search an anime.',
          datatype: SchemaDataType.string(),
        ),
        ...TenkaQuery.parseQueryKeys,
      ],
      successResponse:
          getJsonResponse(SchemaDataType.array(searchInfoSchemaDataType)),
      failResponse: getFailJsonResponse(),
    ),
  );

  router.get(
    '/anime/search',
    (final Request request) async {
      final String? terms = request.url.queryParameters['terms'];
      if (terms == null) {
        return ResponseUtils.missingQuery('terms');
      }

      final dynamic parsedQuery =
          await TenkaQuery.parse<AnimeExtractor>(request);

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<AnimeExtractor> castedQuery =
          parsedQuery as TenkaQuery<AnimeExtractor>;

      final String cKey = castedQuery.getCacheKey('search_$terms');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final List<SearchInfo> results;
        final CacheData<List<SearchInfo>>? cached =
            Cache.get<List<SearchInfo>>(cKey);

        if (cached != null) {
          results = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          results =
              await castedQuery.extractor.search(terms, castedQuery.locale);
          Cache.set<List<SearchInfo>>(cKey, results);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(
            results.map((final SearchInfo x) => x.toJson()).toList(),
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

import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/docs/api.dart';
import '../../tools/docs/datatype.dart';
import '../../tools/docs/predefined/schemas/json_response.dart';
import '../../tools/docs/predefined/schemas/manga/page/info.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';

final RouteFactory mangaChapter =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  docs.addRoute(
    ApiRoute(
      heading: 'Get Manga Chapter Pages',
      method: ApiRouteMethod.get,
      path: '/manga/chapter?url={url}&${TenkaQuery.parseQuery}',
      descripton: 'Get pages of a manga chapter.',
      keys: <ApiRouteKey>[
        ApiRouteKey(
          name: 'url',
          description: 'URL of a manga chapter.',
          datatype: SchemaDataType.string(),
        ),
        ...TenkaQuery.parseQueryKeys,
      ],
      successResponse:
          getJsonResponse(SchemaDataType.array(pageInfoSchemaDataType)),
      failResponse: getFailJsonResponse(),
    ),
  );

  router.get(
    '/manga/chapter',
    (final Request request) async {
      final String? url = request.url.queryParameters['url'];
      if (url == null) {
        return ResponseUtils.missingQuery('url');
      }

      final dynamic parsedQuery =
          await TenkaQuery.parse<MangaExtractor>(request);

      if (parsedQuery is Response) return parsedQuery;

      final TenkaQuery<MangaExtractor> castedQuery =
          parsedQuery as TenkaQuery<MangaExtractor>;

      final String cKey = castedQuery.getCacheKey('chapter_$url');

      try {
        int statusCode = StatusCodes.ok;
        final Map<String, String> headers =
            getDefaultHeaders(contentType: ContentType.json);

        final List<PageInfo> results;
        final CacheData<List<PageInfo>>? cached =
            Cache.get<List<PageInfo>>(cKey);

        if (cached != null) {
          results = cached.data;
          statusCode = StatusCodes.notModified;
          cached.setCacheHeaders(headers);
        } else {
          results = await castedQuery.extractor.getChapter(
            ChapterInfo(
              // NOTE: not a big issue
              chapter: '0',
              url: url,
              locale: castedQuery.locale,
            ),
          );
          Cache.set<List<PageInfo>>(cKey, results);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(
            results.map((final PageInfo x) => x.toJson()).toList(),
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

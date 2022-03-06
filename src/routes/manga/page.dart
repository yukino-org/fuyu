import 'package:shelf/shelf.dart';
import 'package:tenka/tenka.dart';
import '../../core/cache.dart';
import '../../core/router.dart';
import '../../tools/docs/api.dart';
import '../../tools/docs/datatype.dart';
import '../../tools/docs/predefined/schemas/image_describer_proxy.dart';
import '../../tools/docs/predefined/schemas/json_response.dart';
import '../../tools/http.dart';
import '../../tools/logger.dart';
import '../../tools/response.dart';
import '../../tools/utils.dart';
import '../proxy.dart';

final RouteFactory mangaPage =
    createRouteFactory((final Router router, final ApiDocs docs) async {
  docs.addRoute(
    ApiRoute(
      heading: 'Get Manga Chapter Page',
      method: ApiRouteMethod.get,
      path: '/manga/chapter?url={url}&${TenkaQuery.parseQuery}',
      descripton: 'Get image of the manga chapter page.',
      keys: <ApiRouteKey>[
        ApiRouteKey(
          name: 'url',
          description: 'URL of the manga chapter page.',
          datatype: SchemaDataType.string(),
        ),
        ...TenkaQuery.parseQueryKeys,
      ],
      successResponse: getJsonResponse(imageDescriberProxySchemaDataType),
      failResponse: getFailJsonResponse(),
    ),
  );

  router.get(
    '/manga/page',
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
          result = await castedQuery.extractor.getPage(url, castedQuery.locale);
          Cache.set<ImageDescriber>(cKey, result);
        }

        return Response(
          statusCode,
          body: JsonResponse.success(
            result.toJson()
              ..addAll(<dynamic, dynamic>{
                'proxied_url': getProxiedURL(result.url, result.headers),
              }),
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

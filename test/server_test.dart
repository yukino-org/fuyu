import 'dart:convert';
import 'package:http/http.dart';
import 'package:tenka/tenka.dart';
import 'package:test/test.dart';
import '../src/core/app.dart' as server;
import '../src/main.dart' as server;

const String host = '127.0.0.1';
const int port = 8080;
const Map<TenkaType, String> modules = <TenkaType, String>{
  TenkaType.anime: 'gogoanime.pe',
  TenkaType.manga: 'mangadex.org',
};

const String defaultLocale = 'en';

void main() {
  setUpAll(() async {
    await server.main(
      <String>[
        '--host',
        host,
        '--port',
        port.toString(),
        '--modules',
        modules.values.join(','),
        '--suppress',
      ],
    );
  });

  tearDownAll(() async {
    server.AppManager.quit();
  });

  group('/anime', () {
    final Map<String, String> defaultQuery = <String, String>{
      'module': modules[TenkaType.anime]!,
      'locale': defaultLocale,
    };

    final Map<String, String> urls = <String, String>{};

    test('/anime/search', () async {
      final Response response = await get(
        getURI('/anime/search', <String, String>{
          'terms': 'bunny girl',
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () {
              final SearchInfo result = SearchInfo.fromJson(
                (data as List<dynamic>).first as Map<dynamic, dynamic>,
              );

              urls['anime'] = result.url;
            },
          ),
        ),
        true,
      );
    });

    test('/anime/info', () async {
      final Response response = await get(
        getURI('/anime/info', <String, String>{
          'url': urls['anime']!,
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () {
              final AnimeInfo result =
                  AnimeInfo.fromJson(data as Map<dynamic, dynamic>);

              urls['episode'] = result.sortedEpisodes.first.url;
            },
          ),
        ),
        true,
      );
    });

    test('/anime/sources', () async {
      final Response response = await get(
        getURI('/anime/sources', <String, String>{
          'url': urls['episode']!,
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () => EpisodeSource.fromJson(
              (data as List<dynamic>).first as Map<dynamic, dynamic>,
            ),
          ),
        ),
        true,
      );
    });
  });

  group('/manga', () {
    final Map<String, String> defaultQuery = <String, String>{
      'module': modules[TenkaType.manga]!,
      'locale': defaultLocale,
    };

    final Map<String, String> urls = <String, String>{};

    test('/manga/search', () async {
      final Response response = await get(
        getURI('/manga/search', <String, String>{
          'terms': 'bunny girl',
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () {
              final SearchInfo result = SearchInfo.fromJson(
                (data as List<dynamic>).first as Map<dynamic, dynamic>,
              );

              urls['manga'] = result.url;
            },
          ),
        ),
        true,
      );
    });

    test('/manga/info', () async {
      final Response response = await get(
        getURI('/manga/info', <String, String>{
          'url': urls['manga']!,
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () {
              final MangaInfo result =
                  MangaInfo.fromJson(data as Map<dynamic, dynamic>);

              urls['chapter'] = result.sortedChapters.first.url;
            },
          ),
        ),
        true,
      );
    });

    test('/manga/chapter', () async {
      final Response response = await get(
        getURI('/manga/chapter', <String, String>{
          'url': urls['chapter']!,
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () {
              final PageInfo result = PageInfo.fromJson(
                (data as List<dynamic>).first as Map<dynamic, dynamic>,
              );

              urls['page'] = result.url;
            },
          ),
        ),
        true,
      );
    });

    test('/manga/page', () async {
      final Response response = await get(
        getURI('/manga/page', <String, String>{
          'url': urls['page']!,
          ...defaultQuery,
        }),
      );

      expect(
        isSuccessResponse(
          response,
          (final dynamic data) => tryCatchBool(
            () => ImageDescriber.fromJson(data as Map<dynamic, dynamic>),
          ),
        ),
        true,
      );
    });
  });
}

Uri getURI(final String route, final Map<String, String> query) => Uri(
      scheme: 'http',
      host: host,
      port: port,
      path: route,
      queryParameters: query,
    );

bool isSuccessResponse(
  final Response response,
  final bool Function(dynamic) isValid,
) {
  final Map<dynamic, dynamic> parsed =
      json.decode(response.body) as Map<dynamic, dynamic>;

  return <int>[200, 304].contains(response.statusCode) &&
      parsed['success'] as bool &&
      isValid(parsed['data']);
}

bool tryCatchBool(final void Function() fn) {
  try {
    fn();
    return true;
  } catch (_) {
    return false;
  }
}

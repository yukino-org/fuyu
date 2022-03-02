import 'dart:io';

import 'package:tenka/tenka.dart';
import 'package:utilx_desktop/utilities/webview/providers/puppeteer/provider.dart';
import '../config/constants.dart';
import '../config/paths.dart';
import 'app.dart';

Map<String, String>? _storeIdNameMap;
final Map<String, dynamic> _cachedExtractors = <String, dynamic>{};

extension TenkaRepositoryUtils on TenkaRepository {
  Map<String, String> get storeNameIdMap =>
      _storeIdNameMap ??= store.modules.map(
        (final String i, final TenkaMetadata x) => MapEntry<String, String>(
          x.name.toLowerCase(),
          x.id,
        ),
      );
}

abstract class TenkaManager {
  static late final TenkaRepository repository;

  static Future<void> initialize() async {
    await TenkaInternals.initialize(
      runtime: TenkaRuntimeOptions(
        http: const TenkaRuntimeHttpClientOptions(
          ignoreSSLCertificate: true,
        ),
        webview: WebviewManagerInitializeOptions(
          PuppeteerProvider(),
          WebviewProviderOptions(localChromiumPath: Paths.chromium),
        ),
      ),
    );

    // Remove all installed modules
    final Directory tenkaBaseDir = Directory(Paths.tenka);
    if (await tenkaBaseDir.exists()) {
      await tenkaBaseDir.delete(recursive: true);
    }

    repository = TenkaRepository(
      resolver:
          const TenkaStoreURLResolver(deployMode: Constants.tenkaStoreRef),
      baseDir: Paths.tenka,
    );

    await repository.initialize();

    for (final String x
        in (AppManager.argResults['modules'] as List<dynamic>).cast<String>()) {
      final TenkaMetadata? metadata =
          repository.store.modules[repository.storeNameIdMap[x]];
      if (metadata == null) throw Exception('Invalid module: $x');

      await repository.install(metadata);
    }
  }

  static Future<T> getExtractor<T>(final TenkaMetadata metadata) async {
    if (!_cachedExtractors.containsKey(metadata.id)) {
      final TenkaRuntimeInstance runtime = await TenkaRuntimeManager.create();
      await runtime.loadScriptCode('', appendDefinitions: true);
      await runtime.loadByteCode((metadata.source as TenkaBase64DS).data);
      _cachedExtractors[metadata.id] = await runtime.getExtractor<T>();
    }

    return _cachedExtractors[metadata.id] as T;
  }

  static Future<void> dispose() async {
    await TenkaInternals.dispose();
  }
}

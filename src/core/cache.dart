import 'dart:io';

class CacheData<T> {
  const CacheData(this.data, this.cachedAt);

  final T data;
  final DateTime cachedAt;

  void setCacheHeaders(final Map<String, String> headers) {
    headers['Expires'] = HttpDate.format(expiresAt);
  }

  DateTime get expiresAt => cachedAt.add(Cache.lifetime);

  bool get expired =>
      DateTime.now().millisecondsSinceEpoch > expiresAt.millisecondsSinceEpoch;
}

abstract class Cache {
  static final Map<dynamic, CacheData<dynamic>> _cache =
      <dynamic, CacheData<dynamic>>{};

  static CacheData<T>? get<T>(final String key) {
    CacheData<T>? data = _cache[key] as CacheData<T>?;
    if (data?.expired ?? false) {
      data = null;
      _cache.remove(key);
    }
    return data;
  }

  static CacheData<T> set<T>(final String key, final T data) =>
      _cache[key] = CacheData<T>(data, DateTime.now());

  static const Duration lifetime = Duration(minutes: 20);
}

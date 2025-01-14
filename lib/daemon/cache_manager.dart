import 'dart:collection';

class CacheManager {
  final _cache = HashMap<String, dynamic>();
  final Duration _defaultTtl = Duration(minutes: 5); // Default TTL

  // Store data in cache with configurable TTL
  void setCache(String key, dynamic value, {Duration? ttl}) {
    final expiry = DateTime.now().add(ttl ?? _defaultTtl);
    _cache[key] = {'value': value, 'expiry': expiry};
  }

  // Get data from cache
  dynamic getCache(String key) {
    if (_cache.containsKey(key)) {
      final cacheData = _cache[key];
      if (cacheData['expiry'].isAfter(DateTime.now())) {
        return cacheData['value'];
      } else {
        _cache.remove(key); // Remove expired data
      }
    }
    return null;
  }

  // Clear specific cache entry
  void clearCache(String key) {
    _cache.remove(key);
  }

  // Clear all cache
  void clearAllCache() {
    _cache.clear();
  }
}

extension MapExtension<K, V> on Map<K, V> {
  V? select(String path) {
    if (containsKey(path)) return this[path];

    if (path.contains('.')) {
      List<String> keys = path.split('.');

      var value = this[keys.first];
      for (var i = 1; i < keys.length; i++) {
        if (value is Map<String, V>) value = value[keys[i]];
      }

      return value;
    }

    return null;
  }
}

dynamic nullIfEmptyString(Map<dynamic, dynamic> json, String key) {
  final value = json[key] as String?;
  if (value != null) {
    return value.isNotEmpty ? value : null;
  }
  return null;
}

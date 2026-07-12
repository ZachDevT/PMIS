String normalizeRealtimeUrl(String url) {
  if (url.isEmpty) return url;

  // Remove trailing port :0 if present
  url = url.replaceAll(':0', '');

  // Ensure websocket scheme is used
  if (url.startsWith('http://')) {
    url = url.replaceFirst('http://', 'ws://');
  } else if (url.startsWith('https://')) {
    url = url.replaceFirst('https://', 'wss://');
  }

  // Remove any stray fragment markers at end
  if (url.endsWith('#')) url = url.substring(0, url.length - 1);

  return url;
}

String maskApiKeyInUrl(String url) {
  try {
    final uri = Uri.parse(url);
    final query = Map<String, String>.from(uri.queryParameters);
    if (query.containsKey('apikey')) query['apikey'] = '[REDACTED]';
    final masked = uri.replace(queryParameters: query).toString();
    return masked;
  } catch (_) {
    return url;
  }
}

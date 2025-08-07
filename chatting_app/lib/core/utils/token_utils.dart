import 'dart:convert';

bool isTokenValid(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return false;

    final payload = base64Url.normalize(parts[1]);
    final decoded = json.decode(utf8.decode(base64Url.decode(payload)));

    final exp = decoded['exp'];
    if (exp == null) return false;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isBefore(expiryDate);
  } catch (e) {
    return false;
  }
}
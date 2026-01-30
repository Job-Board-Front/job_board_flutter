import '../constants/api_constants.dart';

String? absoluteUrl(String? url) {
  if (url == null) return null;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;

  final separator = url.startsWith('/') ? '' : '/';
  return '${ApiConstants.baseUrl}/uploads/job-logos$separator$url';
}

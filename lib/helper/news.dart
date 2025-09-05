import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ktg_news_app/models/article.dart';

class News {
  List<Article> news = [];

  Future<void> getNews(
      String catNameKey,
      String pageNo,
      String perPage,
      String isHot,
      String isNew,
      String id,
      ) async {
    news = await _fetchNews(
      catNameKey: catNameKey,
      pageNo: pageNo,
      perPage: perPage,
      isHot: isHot,
      isNew: isNew,
      id: id,
    );
  }
}

class NewsForCategorie {
  List<Article> news = [];

  Future<void> getNewsForCategory(
      String catNameKey,
      String pageNo,
      String perPage,
      String isHot,
      String isNew,
      String id,
      ) async {
    news = await _fetchNews(
      catNameKey: catNameKey,
      pageNo: pageNo,
      perPage: perPage,
      isHot: isHot,
      isNew: isNew,
      id: id,
    );
  }
}

/// -------------------- PRIVATE HELPERS --------------------

Future<List<Article>> _fetchNews({
  required String catNameKey,
  required String pageNo,
  required String perPage,
  required String isHot,
  required String isNew,
  required String id,
}) async {
  final apiBase = dotenv.env['API_URL'] ?? '';
  if (apiBase.isEmpty) {
    throw Exception('Missing API_URL in .env');
  }

  // Có thể đặt trong .env để bảo mật tốt hơn:
  // BASIC_USERNAME=...
  // BASIC_PASSWORD=...
  final username = dotenv.env['BASIC_USERNAME'] ?? 'tuanduong';
  final password = dotenv.env['BASIC_PASSWORD'] ?? 'Tu@n02121985';
  final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  final uri = Uri.parse('$apiBase/news_home').replace(queryParameters: {
    'cat_name_key': catNameKey,
    'page_no': pageNo,
    'per_page': perPage,
    'is_hot': isHot,
    'is_new': isNew,
    'id': id,
  });

  final resp = await http
      .get(uri, headers: {'authorization': basicAuth})
      .timeout(const Duration(seconds: 20));

  if (resp.statusCode != 200) {
    throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
  }

  final body = jsonDecode(resp.body);
  final list = body is List
      ? body
      : (body is Map && body['items'] is List ? body['items'] as List : const []);

  final result = <Article>[];
  for (final e in list) {
    if (e is! Map) continue;
    result.add(Article(
      title: e['game_news_title'] as String?,
      author: e['cat_name_key'] as String?,
      description: e['game_news_description'] as String?,
      urlToImage: e['game_news_img']?.toString(),
      publshedAt: _parseDate(e['game_news_date']),
      // content: e['game_news_content'] as String?,
      articleUrl: e['media_domain_name']?.toString(),
      categoryCatName: e['cat_name'] as String?,
      catNameKey: e['cat_name_key']?.toString(),
      gameNewsKey: e['game_news_key']?.toString(),
      id: e['id']?.toString(),
      newsCatId: e['news_cat_id']?.toString(),
      newsSource: e['news_source'] as String?,
      newsLink: e['game_news_link']?.toString(),
    ));
  }
  return result;
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) {
    try {
      return DateTime.parse(v);
    } catch (_) {
      return null;
    }
  }
  if (v is num) {
    final ms = v < 2000000000 ? (v * 1000).toInt() : v.toInt();
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }
  return null;
}

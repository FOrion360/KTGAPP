import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ktg_news_app/models/article_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsDetailProcess {
  final List<ArticleDetails> newsDetail = [];

  Future<void> getNewsDetail(
      String catNameKey,
      String pageNo,
      String perPage,
      String isHot,
      String isNew,
      String id,
      ) async {
    newsDetail.clear();

    final apiBase = dotenv.env['API_URL'] ?? '';
    if (apiBase.isEmpty) {
      throw Exception('Missing API_URL in .env');
    }

    // Khuyến nghị đặt trong .env:
    // BASIC_USERNAME=...
    // BASIC_PASSWORD=...
    final username = dotenv.env['BASIC_USERNAME'] ?? 'tuanduong';
    final password = dotenv.env['BASIC_PASSWORD'] ?? 'Tu@n02121985';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final uri = Uri.parse('$apiBase/news_details').replace(queryParameters: {
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

    final data = jsonDecode(resp.body);

    // Dữ liệu có thể là List hoặc bọc trong Map {'items': [...]}
    final list = data is List
        ? data
        : (data is Map && data['items'] is List ? data['items'] as List : const []);

    for (final e in list) {
      final content = (e is Map && e['game_news_content'] is String)
          ? e['game_news_content'] as String
          : null;
      newsDetail.add(ArticleDetails(content: content));
    }
  }
}

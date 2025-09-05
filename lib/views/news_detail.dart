import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ktg_news_app/models/article.dart';

class NewsDetail extends StatelessWidget {
  const NewsDetail({super.key, required this.item});

  final Article item;

  @override
  Widget build(BuildContext context) {
    final String publishedText = _formatPublished(item);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title ?? ''), // null-safe
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.videogame_asset),
            if (publishedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  publishedText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Html(data: "<b>${item.description ?? ''}</b>"),
            // Html(data: item.content ?? ''),
          ],
        ),
      ),
    );
  }

  // Article đang dùng field DateTime? 'publshedAt'
  String _formatPublished(Article a) {
    final p = a.publshedAt;
    if (p == null) return '';
    // Không dùng intl: hiển thị ISO local đơn giản
    return p.toLocal().toString();
  }
}

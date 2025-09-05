class Article {
  final String? title;
  final String? author;
  final String? description;
  final String? urlToImage;
  final DateTime? publshedAt; // giữ nguyên chính tả như code cũ
  // final String? content;
  final String? articleUrl;
  final String? categoryCatName;
  final String? catNameKey;
  final String? gameNewsKey;
  final String? id;
  final String? newsCatId;
  final String? newsSource;
  final String? newsLink;

  const Article({
    this.title,
    this.author,
    this.description,
    this.urlToImage,
    this.publshedAt,
    // this.content,
    this.articleUrl,
    this.categoryCatName,
    this.catNameKey,
    this.gameNewsKey,
    this.id,
    this.newsCatId,
    this.newsSource,
    this.newsLink,
  });

  /// Parse linh hoạt: hỗ trợ cả 'publshedAt', 'publishedAt' hoặc 'published_at',
  /// và cả dạng số timestamp (ms / s) nếu API trả về số.
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] as String?,
      author: map['author'] as String?,
      description: map['description'] as String?,
      urlToImage: (map['urlToImage'] ?? map['image'])?.toString(),
      publshedAt: _parseDate(map['publshedAt'] ?? map['publishedAt'] ?? map['published_at']),
      // content: map['content'] as String?,
      articleUrl: (map['articleUrl'] ?? map['url'])?.toString(),
      categoryCatName: map['categoryCatName'] as String?,
      catNameKey: map['catNameKey']?.toString(),
      gameNewsKey: map['gameNewsKey']?.toString(),
      id: map['id']?.toString(),
      newsCatId: map['newsCatId']?.toString(),
      newsSource: map['newsSource'] as String?,
      newsLink: map['newsLink'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'author': author,
    'description': description,
    'urlToImage': urlToImage,
    'publshedAt': publshedAt?.toIso8601String(),
    // 'content': content,
    'articleUrl': articleUrl,
    'categoryCatName': categoryCatName,
    'catNameKey': catNameKey,
    'gameNewsKey': gameNewsKey,
    'id': id,
    'newsCatId': newsCatId,
    'newsSource': newsSource,
    'newsLink': newsLink,
  };

  Article copyWith({
    String? title,
    String? author,
    String? description,
    String? urlToImage,
    DateTime? publshedAt,
    // String? content,
    String? articleUrl,
    String? categoryCatName,
    String? catNameKey,
    String? gameNewsKey,
    String? id,
    String? newsCatId,
    String? newsSource,
    String? newsLink,
  }) {
    return Article(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      urlToImage: urlToImage ?? this.urlToImage,
      publshedAt: publshedAt ?? this.publshedAt,
      // content: content ?? this.content,
      articleUrl: articleUrl ?? this.articleUrl,
      categoryCatName: categoryCatName ?? this.categoryCatName,
      catNameKey: catNameKey ?? this.catNameKey,
      gameNewsKey: gameNewsKey ?? this.gameNewsKey,
      id: id ?? this.id,
      newsCatId: newsCatId ?? this.newsCatId,
      newsSource: newsSource ?? this.newsSource,
      newsLink: newsLink ?? this.newsLink,
    );
  }

  static DateTime? _parseDate(dynamic v) {
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
      // nếu là timestamp giây → *1000, nếu là mili giây giữ nguyên
      final ms = v < 20000 ? (v * 1000).toInt() : v.toInt();
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }
    return null;
  }
}

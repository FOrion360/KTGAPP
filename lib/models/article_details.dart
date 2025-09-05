class ArticleDetails {
  final String? content;

  const ArticleDetails({this.content});

  factory ArticleDetails.fromMap(Map<String, dynamic> map) {
    return ArticleDetails(content: map['content'] as String?);
  }

  Map<String, dynamic> toMap() => {'content': content};

  ArticleDetails copyWith({String? content}) {
    return ArticleDetails(content: content ?? this.content);
  }
}

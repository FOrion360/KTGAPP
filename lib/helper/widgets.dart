import 'package:flutter/material.dart';
import 'package:ktg_news_app/views/article_view.dart';
import 'package:intl/intl.dart';
import 'package:html_character_entities/html_character_entities.dart';

/// AppBar hợp lệ cho Scaffold.appBar
PreferredSizeWidget MyAppBar() {
  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text(
          "Kênh Tin ",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        Text(
          "Game",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        ),
      ],
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}

class NewsTile extends StatelessWidget {
  const NewsTile({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.desc,
    this.content = '',
    required this.posturl,
    required this.categoryCatName,
    required this.publshedAt, // giữ nguyên tên cũ
    required this.catNameKey,
    required this.gameNewsKey,
    required this.id,
    required this.newsCatId,
    required this.newsSource,
  });

  final String imgUrl;
  final String title;
  final String desc;
  final String content;
  final String posturl;
  final String categoryCatName;
  final String publshedAt;
  final String catNameKey;
  final String gameNewsKey;
  final String id;
  final String newsCatId;
  final String newsSource;

  @override
  Widget build(BuildContext context) {
    final String safeTitle = HtmlCharacterEntities.decode(title);

    final String formattedDate = () {
      try {
        final dt = DateTime.parse(publshedAt);
        return DateFormat('dd-MM-yyyy HH:mm:ss').format(dt);
      } catch (_) {
        return publshedAt; // fallback nếu parse lỗi
      }
    }();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleView(
              urlToImage: imgUrl,
              title: title,
              desc: desc,
              // content: content,
              postUrl: posturl,
              categoryCatName: categoryCatName,
              publshedAt: publshedAt,
              catNameKey: catNameKey,
              gameNewsKey: gameNewsKey,
              id: id,
              newsCatId: newsCatId,
              newsSource: newsSource,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categoryCatName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imgUrl,
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              safeTitle,
              maxLines: 10,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      newsSource,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _removeAllHtmlTags(desc.trim()),
              maxLines: 20,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.black54, fontSize: 18),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  static final RegExp _tagExp =
  RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  String _removeAllHtmlTags(String input) => input.replaceAll(_tagExp, '');
}

import 'package:flutter/material.dart';
import 'package:ktg_news_app/views/article_view.dart';
import 'package:intl/intl.dart';
import 'package:html_character_entities/html_character_entities.dart';

Widget MyAppBar(){
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Kênh Tin ",
          style:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        Text(
          "Game",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        )
      ],
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}


class NewsTile extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl, categoryCatName, publshedAt, catNameKey
  , gameNewsKey, id, newsCatId, newsSource;

  NewsTile({this.imgUrl, this.desc, this.title, this.content, this.posturl, this.categoryCatName, this.publshedAt, this.catNameKey
    , this.gameNewsKey, this.id, this.newsCatId, this.newsSource});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ArticleView(
                    urlToImage: imgUrl,
                    title: title,
                    desc: desc,
                    //content: content,
                    postUrl: posturl,
                    categoryCatName: categoryCatName,
                    publshedAt: publshedAt,
                    catNameKey: catNameKey,
                    gameNewsKey: gameNewsKey,
                    id: id,
                    newsCatId: newsCatId,
                    newsSource: newsSource
                )
        ));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imgUrl,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )),
                  Text(
                    HtmlCharacterEntities.decode(title),
                    maxLines: 10,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                    child: Row(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.calendar_today, size: 16)
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime
                                  .parse(publshedAt)),
                              style: TextStyle(fontSize: 16.0),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
}

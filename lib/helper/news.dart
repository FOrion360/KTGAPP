import 'package:http/http.dart' as http;
import 'package:ktg_news_app/models/article.dart';
import 'dart:convert';
import 'dart:io';

import 'package:ktg_news_app/secret.dart';
import 'package:flutter_config/flutter_config.dart';

String username = 'tuanduong';
String password = 'Tu@n02121985';

String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$username:$password'));

class News {

  List<Article> news  = [];

  Future<void> getNews(String catNameKey, String pageNo, String perPage, String isHot, String isNew, String id) async{
    String url = FlutterConfig.get('API_URL') + '/news_home?cat_name_key=' + catNameKey + '&page_no=' + pageNo + '&per_page=' + perPage
        + '&is_hot=' + isHot + '&is_new=' + isNew + '&id=' + id;

    var response = await http.get(Uri.parse(url), headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        jsonData.forEach((element){
          Article article = Article(
            title: element['game_news_title'],
            author: element['cat_name_key'],
            description: element['game_news_description'],
            urlToImage: element['game_news_img'],
            publshedAt: DateTime.parse(element['game_news_date']),
            //content: element["game_news_content"],
            articleUrl: element["media_domain_name"],
            categoryCatName: element["cat_name"],
            catNameKey: element["cat_name_key"],
            gameNewsKey: element["game_news_key"],
            id: element["id"],
            newsCatId: element["news_cat_id"],
            newsSource: element["news_source"],
            newsLink: element["game_news_link"],
          );
          news.add(article);
        });
    }
  }
}

class NewsForCategorie {

  List<Article> news  = [];

  Future<void> getNewsForCategory(String catNameKey, String pageNo, String perPage, String isHot, String isNew, String id) async{
    String url = FlutterConfig.get('API_URL') + '/news_home?cat_name_key=' + catNameKey + '&page_no=' + pageNo + '&per_page=' + perPage
        + '&is_hot=' + isHot + '&is_new=' + isNew + '&id=' + id;

    var response = await http.get(Uri.parse(url), headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      jsonData.forEach((element){
        Article article = Article(
          title: element['game_news_title'],
          author: element['cat_name_key'],
          description: element['game_news_description'],
          urlToImage: element['game_news_img'],
          publshedAt: DateTime.parse(element['game_news_date']),
          //content: element["game_news_content"],
          articleUrl: element["media_domain_name"],
          categoryCatName: element["cat_name"],
          catNameKey: element["cat_name_key"],
          gameNewsKey: element["game_news_key"],
          id: element["id"],
          newsCatId: element["news_cat_id"],
          newsSource: element["news_source"],
          newsLink: element["game_news_link"],
        );
        news.add(article);
      });
    }
  }


}



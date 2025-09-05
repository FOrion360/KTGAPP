import 'package:http/http.dart' as http;
import 'package:ktg_news_app/models/article_details.dart';
import 'dart:convert';
import 'dart:io';

import 'package:ktg_news_app/secret.dart';
import 'package:flutter_config/flutter_config.dart';

String username = 'tuanduong';
String password = 'Tu@n02121985';

String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$username:$password'));

class NewsDetailProcess {

  List<ArticleDetails> newsDetail  = [];

  Future<void> getNewsDetail(String catNameKey, String pageNo, String perPage, String isHot, String isNew, String id) async{
    String url = FlutterConfig.get('API_URL') + '/news_details?cat_name_key=' + catNameKey + '&page_no=' + pageNo + '&per_page=' + perPage
        + '&is_hot=' + isHot + '&is_new=' + isNew + '&id=' + id;

    var response = await http.get(Uri.parse(url), headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      jsonData.forEach((element){
        ArticleDetails article = ArticleDetails(
          content: element["game_news_content"]
        );
        newsDetail.add(article);
      });
    }
  }
}

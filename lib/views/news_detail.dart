import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ktg_news_app/models/article.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NewsDetail extends StatelessWidget {
  NewsDetail({Key key, this.item}) : super(key: key);
  final Article item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.item.title),
      ),
      body:
      SingleChildScrollView( child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.videogame_asset),
          Text(this.item.publshedAt.toString()),
          Html(data: "<b>" + this.item.description + "</b>"),
          //Html(data: this.item.content),
        ],
      )),

    );
  }
}
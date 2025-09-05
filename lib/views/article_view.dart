import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helper/news.dart';
import '../helper/news_detail.dart';
import 'package:ktg_news_app/helper/widgets_hotnews.dart';
import 'package:ktg_news_app/models/article.dart';

import 'package:http/http.dart' as http;
import 'package:ktg_news_app/models/article.dart';
import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

var newsListRelated;
var _newsDetail;

//Related News
class RelatedNewsByCat extends StatefulWidget {
  const RelatedNewsByCat({Key key}) : super(key: key);

  @override
  _RelatedNewsByCatState createState() => _RelatedNewsByCatState();
}

class _RelatedNewsByCatState extends State<RelatedNewsByCat> {
  Widget build(BuildContext context) {
    if(newsListRelated != null) {
      return
        Container(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ///Html(data: "<h2 style='text-decoration: underline;'>CÙNG CHUYÊN MỤC</h2>"),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: ListView.builder(
                itemCount: newsListRelated.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return NewsTile(
                    imgUrl: newsListRelated[index].urlToImage ?? "",
                    title: newsListRelated[index].title ?? "",
                    desc: newsListRelated[index].description ?? "",
                    //content: newsListRelated[index].content ?? "",
                    posturl: newsListRelated[index].articleUrl ?? "",
                    categoryCatName: newsListRelated[index].categoryCatName ?? "",
                    publshedAt: newsListRelated[index].publshedAt.toString() ?? "",
                    catNameKey: newsListRelated[index].catNameKey.toString() ?? "",
                    gameNewsKey: newsListRelated[index].gameNewsKey.toString() ?? "",
                    id: newsListRelated[index].id.toString() ?? "",
                    newsCatId: newsListRelated[index].newsCatId.toString() ?? "",
                    newsSource: newsListRelated[index].newsSource.toString() ?? "",
                  );
                },
              ),
            ),

          ],
        ),
        );
    }
    else{
      return Text("");
    }
  }
}

//Hot News
var newsListHot;
class HotNewsByCat extends StatefulWidget {
  const HotNewsByCat({Key key}) : super(key: key);

  @override
  _HotNewsByCatState createState() => _HotNewsByCatState();
}

class _HotNewsByCatState extends State<HotNewsByCat> {
  Widget build(BuildContext context) {
    if(newsListHot != null) {
      return
        Container(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ///Html(data: "<h2 style='text-decoration: underline;'>CÙNG CHUYÊN MỤC</h2>"),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: ListView.builder(
                itemCount: newsListHot.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return NewsTile(
                    imgUrl: newsListHot[index].urlToImage ?? "",
                    title: newsListHot[index].title ?? "",
                    desc: newsListHot[index].description ?? "",
                    //content: newsListHot[index].content ?? "",
                    posturl: newsListHot[index].articleUrl ?? "",
                    categoryCatName: newsListHot[index].categoryCatName ?? "",
                    publshedAt: newsListHot[index].publshedAt.toString() ?? "",
                    catNameKey: newsListHot[index].catNameKey.toString() ?? "",
                    gameNewsKey: newsListHot[index].gameNewsKey.toString() ?? "",
                    id: newsListHot[index].id.toString() ?? "",
                    newsCatId: newsListHot[index].newsCatId.toString() ?? "",
                    newsSource: newsListHot[index].newsSource.toString() ?? "",
                  );
                },
              ),
            ),

          ],
        ),
        );
    }
    else{
      return Text("");
    }
  }
}

//News Detail
class NewsDetail extends StatefulWidget {
  const NewsDetail({Key key}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();

  getNewsDetail(String catNameKey, String pageNo, String s, String t, String u, String id) {}
}

class _NewsDetailState extends State<NewsDetail> {
  Widget build(BuildContext bcontext) {
    if(_newsDetail != null) {
      return
        Container(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0),
              child: ListView.builder(
                itemCount: _newsDetail.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return
                  Html(data: _newsDetail[index].content ?? "",
                    onLinkTap: (String url, RenderContext context,
                        Map<String, String> attributes, dom.Element element) {
                      //open URL in webview, or launch URL in browser, or any other logic here
                      //launch(url);

                      showAlertDialog(bcontext, url);
                    },
                    customImageRenders: {
                      // networkSourceMatcher(domains: ["flutter.dev"]):
                      //     (context, attributes, element) {
                      //   return FlutterLogo(size: 36);
                      // },
                      // networkSourceMatcher(): networkImageRender(
                      //   headers: {"Custom-Header": "some-value"},
                      //   altWidget: (alt) => Text(alt ?? ""),
                      //   loadingWidget: () => Text("Loading..."),
                      // ),
                      //     (attr, _) => attr["src"] != null && attr["src"].startsWith("/game4v"):
                      // networkImageRender(
                      //     mapUrl: (url) => "https://upload.wikimedia.org" + url),
                    },
                  );
                },
              ),
            ),
          ],
        ),
        );
    }
    else{
      return Text("");
    }
  }

  showAlertDialog(BuildContext context, String url) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Hủy bỏ"),
      onPressed:  () { Navigator.of(context).pop(); },
    );
    Widget continueButton = TextButton(
      child: Text("Tiếp tục"),
      onPressed:  () { launch(url); Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông Báo"),
      content: Text("Bạn có thật sự muốn truy cập liên kết: " + url + " ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ArticleView extends StatefulWidget {
  final String urlToImage;
  final String title;
  final String desc;
  //final String content;
  final String postUrl;
  final String categoryCatName;
  final String publshedAt;
  final String catNameKey;
  final String gameNewsKey;
  final String id;
  final String newsCatId;
  final String newsSource;

  ArticleView({this.urlToImage, this.title, this.desc,
    //this.content,
    this.postUrl, this.categoryCatName, this.publshedAt, this.catNameKey
    , this.gameNewsKey, this.id, this.newsCatId, this.newsSource});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> with TickerProviderStateMixin {
  //Admod
  BannerAd _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery
            .of(context)
            .size
            .width
            .truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      // TODO: replace these test ad units with your own ad unit.
      adUnitId: Platform.isAndroid
          ? FlutterConfig.get('GOOGLE_ADMOD_BANNER_ID')
          : FlutterConfig.get('GOOGLE_ADMOD_BANNER_ID'),
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd.load();
  }

  //Admod

  bool _loading = true;
  bool _visible = false;
  BottomLoader bl;
  ScrollController _scrollController;
  bool _showBackToTopButton = false;

  _scrollListener() {
    // if (_scrollController.offset >= 200) {
    //   if(!_showBackToTopButton) {
    //     _showBackToTopButton = true; // show the back-to-top button
    //   }
    // } else {
    //   _showBackToTopButton = false; // hide the back-to-top button
    // }
  }

  //NewsDetail
  void getNewsDetail(String catNameKey, String pageNo) async {
    //bl.display();
    _visible = false;
    EasyLoading.show(status: 'Đang tải...');

    //News Detail
    NewsDetailProcess newsDetailProcess = NewsDetailProcess();
    await newsDetailProcess.getNewsDetail(
        catNameKey, pageNo, '5', 'false', 'true', widget.id);
    _newsDetail = newsDetailProcess.newsDetail;

    setState(() {
      //bl.hide();
      _visible = true;
      EasyLoading.dismiss();
    });
  }

  //NewsRelated
  void getNewsRelated(String catNameKey, String pageNo) async {
    //bl.display();
    _visible = false;

    News news = News();
    await news.getNews(catNameKey, pageNo, '5', 'false', 'true', widget.id);
    newsListRelated = news.news;

    setState(() {
      //bl.hide();
      _visible = true;
    });
  }

  //NewsHot
  void getNewsHot(String catNameKey, String pageNo) async {
    //bl.display();
    _visible = false;

    News news = News();
    await news.getNews(catNameKey, pageNo, '5', 'true', 'false', widget.id);
    newsListHot = news.news;

    setState(() {
      //bl.hide();
      _visible = true;
    });
  }

  showAlertDialog(BuildContext context, String url) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Hủy bỏ"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Tiếp tục"),
      onPressed: () {
        launch(url);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông Báo"),
      content: Text("Bạn có thật sự muốn truy cập liên kết: " + url + " ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Html DescContentProcess(String desc, int newsCatId) {
    //List<int> g4vId = [19,20,21,22,23,24];
    // if( newsCatId != 19 && newsCatId != 20 && newsCatId != 21 && newsCatId != 22
    //     && newsCatId != 23 && newsCatId != 24){
    //
    // }
    // else{
    //   return Html(data: "");
    // }

    return Html(
        data: "<span style='font-size: 18px; font-style: italic;'><b>" +
            widget.desc + "</b></span>");
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(1,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  void initState() {
    // TODO: implement initState
    String catNameKey = '0';
    if (widget.catNameKey != null) {
      catNameKey = widget.catNameKey;
    }

    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getNewsDetail(widget.catNameKey, '1'));

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getNewsRelated(widget.catNameKey, '1'));

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getNewsHot(widget.catNameKey, '1'));
  }

  final Completer<WebViewController> _controller = Completer<
      WebViewController>();

  @override
  Widget build(BuildContext bcontext) {
    bl = new BottomLoader(context);
    bl.style(
        message: 'Đang tải tin tức...',
        backgroundColor: Colors.white,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600)
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.categoryCatName,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          new IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            icon: new Icon(Icons.share),
            highlightColor: Colors.pink,
            onPressed: () async {
              await SocialSharePlugin.shareToFeedFacebookLink(
                  quote: 'Kênh Tin Game - ' + widget.categoryCatName,
                  url: 'https://kenhtingame.com/' + widget.catNameKey + '/1');
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          child: Icon(Icons.arrow_upward),
        ),
      ),
      body:
      Container(
        child: Column(
          children: <Widget>[
            Expanded(child:
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Html(data: "<h2>" + widget.title + "</h2>"),
                    Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.calendar_today)
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                DateFormat('dd-MM-yyyy HH:mm:ss').format(
                                    DateTime.parse(widget.publshedAt)),
                                style: TextStyle(fontSize: 16.0),
                              )
                          ),
                          // Container(
                          //     margin: const EdgeInsets.only( left: 10.0),
                          //     child: Text(
                          //       widget.newsSource,
                          //       style: TextStyle( fontSize: 15.0, color: Colors.black38),
                          //     )
                          // ),
                          new IconButton(
                            icon: new FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blueAccent,),
                            onPressed: () async {
                              await SocialSharePlugin.shareToFeedFacebookLink(
                                  quote: widget.desc,
                                  url: 'https://kenhtingame.com/' +
                                      widget.catNameKey +
                                      '/' + widget.gameNewsKey + '/' +
                                      widget.id);
                            },
                          ),
                          // new IconButton(
                          //   icon: new FaIcon(FontAwesomeIcons.instagram, color: Colors.red,),
                          //   onPressed: () async {
                          //     await SocialSharePlugin.shareToFeedInstagram(quote: 'Kênh Tin Game', url: 'https://kenhtingame.com');
                          //   },
                          // ),
                          new IconButton(
                            icon: new FaIcon(
                              FontAwesomeIcons.twitter, color: Colors.blue,),
                            onPressed: () async {
                              await SocialSharePlugin.shareToTwitterLink(
                                  text: widget.desc,
                                  url: 'https://kenhtingame.com/' +
                                      widget.catNameKey +
                                      '/' + widget.gameNewsKey + '/' +
                                      widget.id);
                            },
                          )
                        ],
                      ),
                    ),
                    DescContentProcess(
                        "<span style='font-size: 18px; font-style: italic;'><b>" +
                            widget.desc + "</b></span>",
                        int.parse(widget.newsCatId))
                    ,
                    NewsDetail(),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      ///color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      height: 1580,
                      child: ContainedTabBarView(
                        tabs: [
                          Text('CÙNG CHUYÊN MỤC', style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16,),),
                          Text('HOT TRONG NGÀY', style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16,),),
                        ],
                        tabBarProperties: TabBarProperties(
                          height: 30.0,
                          indicatorColor: Colors.black,
                          indicatorWeight: 3.0,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                        ),
                        views: [
                          RelatedNewsByCat(),
                          HotNewsByCat()
                        ],
                        onChange: (index) => print(index),
                      ),
                    )
                  ],
                ),
              ),
            )
            ),
            if (_anchoredAdaptiveAd != null && _isLoaded)
              Container(
                color: Colors.green,
                width: _anchoredAdaptiveAd.size.width.toDouble(),
                height: _anchoredAdaptiveAd.size.height.toDouble(),
                child: AdWidget(ad: _anchoredAdaptiveAd),
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ktg_news_app/helper/news.dart';
import 'package:ktg_news_app/helper/widgets.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_config/flutter_config.dart';

class CategoryNews extends StatefulWidget {

  final String newsCategory;
  final String categoryCatName;

  CategoryNews({this.newsCategory, this.categoryCatName});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

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
        MediaQuery.of(context).size.width.truncate());

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

  ScrollController _scrollController;
  int _pageNo = 1;
  BottomLoader bl;
  bool _showBackToTopButton = false;

  var newslist;
  bool _loading = true;

  _scrollListener() {
    // if (_scrollController.offset >= 500) {
    //   _showBackToTopButton = true; // show the back-to-top button
    // } else {
    //   _showBackToTopButton = false; // hide the back-to-top button
    // }

    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo++;
        //message = "reach the bottom" + _pageNo.toString();
        bl.display();
        getNews();
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        //message = "reach the top";
        _pageNo = 1;
        getNews();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    getNews();
    // TODO: implement initState
    super.initState();
  }

  void getNews() async {
    NewsForCategorie news = NewsForCategorie();
    await news.getNewsForCategory(widget.newsCategory, _pageNo.toString(), '10', 'false','false', '0');
    if(newslist != null && _pageNo != 1) {
      newslist += news.news;
    }
    else{
      newslist = news.news;
    }
    setState(() {
       bl.hide();
      _loading = false;
       //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  void getNewsMenu(String newsCategory, String pageNo) async {
    NewsForCategorie news = NewsForCategorie();
    await news.getNewsForCategory(newsCategory, pageNo, '10', 'false','false', '0');
    if(newslist != null && _pageNo != 1) {
      newslist += news.news;
    }
    else{
      newslist = news.news;
    }
    setState(() {
      bl.hide();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bl = new BottomLoader(context);
    bl.style(
        message: 'Đang tải thêm tin tức...',
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
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.share,)),
          )
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
      body: _loading ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        child: Column(
            children: <Widget>[
        Expanded(child:
            Container(
              margin: EdgeInsets.only(top: 16),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: newslist.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NewsTile(
                      imgUrl: newslist[index].urlToImage ?? "",
                      title: newslist[index].title ?? "",
                      desc: newslist[index].description ?? "",
                      //content: newslist[index].content ?? "",
                      posturl: newslist[index].articleUrl ?? "",
                      categoryCatName: newslist[index].categoryCatName ?? "",
                      publshedAt: newslist[index].publshedAt.toString() ?? "",
                      catNameKey: newslist[index].catNameKey.toString() ?? "",
                      gameNewsKey: newslist[index].gameNewsKey.toString() ?? "",
                      id: newslist[index].id.toString() ?? "",
                      newsCatId: newslist[index].newsCatId.toString() ?? "",
                      newsSource: newslist[index].newsSource.toString() ?? "",
                    );
                  }),
            ),
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

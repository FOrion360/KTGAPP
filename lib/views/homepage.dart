import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ktg_news_app/helper/data.dart';
import 'package:ktg_news_app/helper/widgets.dart';
import 'package:ktg_news_app/models/categorie_model.dart';
import 'package:ktg_news_app/views/categorie_news.dart';
import 'package:ktg_news_app/helper/news.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_config/flutter_config.dart';

class NavDrawer extends StatelessWidget {
  List<CategorieModel> categories = getCategories();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            height: 110,
            decoration: BoxDecoration(
                color: Colors.black87,
                image: DecorationImage(
                  //fit: BoxFit.fill,
                    image: AssetImage('assets/ktglogo.png'))),
            // child: Container(
            //     margin: const EdgeInsets.only(top: 5.0, left: 20.0),
            //     child: Text(
            //       'Phiên bản 1.0',
            //       style: TextStyle(color: Colors.white, fontSize: 12),
            //     )
            // )
          ),
          // DrawerHeader(
          //   // child: Text(
          //   //   'Side menu',
          //   //   style: TextStyle(color: Colors.white, fontSize: 25),
          //   // ),
          //   decoration: BoxDecoration(
          //       color: Colors.black87,
          //       image: DecorationImage(
          //           //fit: BoxFit.fill,
          //           image: AssetImage('assets/ktglogo.png'))),
          // ),
          Container(
            //margin: const EdgeInsets.only(top: 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 450,
            child: ListView.builder(
                //padding: EdgeInsets.all(30.0),
                //scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryNav(
                    imageAssetUrl: categories[index].imageAssetUrl,
                    categoryName: categories[index].categorieName,
                    categoryCatName: categories[index].categorieCatName,
                  );
                }),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Liên hệ hợp tác & Quảng cáo'),
            visualDensity: VisualDensity(vertical: -4),
            onTap: () =>
            {
              launch(_emailContactLaunchUri.toString())
            },
          ),
          ListTile(
            leading: Icon(Icons.error),
            title: Text('Báo lỗi ứng dụng'),
            visualDensity: VisualDensity(vertical: -4),
            onTap: () =>
            {
              launch(_emailErrorReportLaunchUri.toString())
            },
          ),
          SizedBox(
            //height: MediaQuery.of(context).size.height - 400,
          ),
          Container(
              margin: const EdgeInsets.only(top: 0.0),
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Html(data:
                '<div style="color: white; font-weight: bold;">Thông Tin Liên Hệ Kênh Tin Game</div>'
                    '<div style="color: white;">- Chịu trách nhiệm nội dung: Đặng Thị Bé</div>'
                    '<div style="color: white;">- Email: kenhtingame@gmail.com</div>'
                    '<div style="color: white;">- Điện thoại: 0394023734</div>')
              ),
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            height: 25,
            decoration: BoxDecoration(
                color: Colors.black87,
               ),
            child: Center(
                child: Text(
                  '© 2017 - ' + getCurrentDate() + ' KTGame - Version 1.1.0',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
            )
          ),
        ],
      ),
    );
  }

  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.year}";
    return formattedDate.toString();
  }

  final Uri _emailContactLaunchUri = Uri(
      scheme: 'mailto',
      path: 'kenhtingame@gmail.com',
      queryParameters: {
        'subject': '[KTG APP] Liên hệ hợp tác & Quảng cáo'
      }
  );

  final Uri _emailErrorReportLaunchUri = Uri(
      scheme: 'mailto',
      path: 'kenhtingame@gmail.com',
      queryParameters: {
        'subject': '[KTG APP] Báo lỗi ứng dụng'
      }
  );

  showAlertDialog(BuildContext context, String title, String messContent) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(messContent),
      actions: [
        okButton,
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  ScrollController _scrollController;
  String message = "";
  int _pageNo = 1;
  BottomLoader bl;
  bool _showBackToTopButton = false;

  bool _loading;
  var newslist;

  List<CategorieModel> categories = List<CategorieModel>();

  void getNews(String catNameKey, String pageNo) async {
    News news = News();
    await news.getNews(catNameKey, pageNo, '10', 'false', 'false', '0');
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
        getNews("0", _pageNo.toString());
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo = 1;
        getNews("0", _pageNo.toString());
        //message = "reach the top";
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
    _loading = true;
    // TODO: implement initState
    super.initState();

    categories = getCategories();
    getNews('0', '1');
    //myBanner.load();
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
      drawer: NavDrawer(),
      appBar: MyAppBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
                Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 16),
                      //   height: 70,
                      //   child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: categories.length,
                      //       itemBuilder: (context, index) {
                      //         return CategoryCard(
                      //           imageAssetUrl: categories[index].imageAssetUrl,
                      //           categoryName: categories[index].categorieName,
                      //           categoryCatName: categories[index].categorieCatName,
                      //         );
                      //       }),
                      // ),
                      Expanded(child:
                      /// News Article
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: newslist.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return NewsTile(
                              imgUrl: newslist[index].urlToImage ?? "",
                              title: newslist[index].title ?? "",
                              desc: removeAllHtmlTags(newslist[index].description) ?? "",
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
                          },
                        ),
                      ),
                      ),
                      //adContainer,
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
      ),
    );
  }
}

// final Container adContainer = Container(
//   alignment: Alignment.center,
//   child: adWidget,
//   width: myBanner.size.width.toDouble(),
//   height: myBanner.size.height.toDouble(),
// );
//
// final AdWidget adWidget = AdWidget(ad: myBanner);
//
// final BannerAd myBanner = BannerAd(
//   adUnitId: FlutterConfig.get('GOOGLE_ADMOD_BANNER_ID'),
//   size: AdSize.banner,
//   request: AdRequest(),
//   listener: BannerAdListener(),
// );

showAlertDialog(BuildContext context, String title, String messContent) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(messContent),
    actions: [
      okButton,
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

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName, categoryCatName, pageNo;

  CategoryCard({this.imageAssetUrl, this.categoryName, this.categoryCatName, this.pageNo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(
              newsCategory: categoryCatName.toLowerCase(),
              categoryCatName : categoryName,
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: imageAssetUrl,
                height: 60,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                color: Colors.black26
              ),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryNav extends StatelessWidget {
  final String imageAssetUrl, categoryName, categoryCatName, pageNo;

  CategoryNav({this.imageAssetUrl, this.categoryName, this.categoryCatName, this.pageNo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              newsCategory: categoryCatName.toLowerCase(),
              categoryCatName : categoryName,
            )
        ));
      },
      child:
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
              child: Container(
                  margin: const EdgeInsets.only(left: 0, right: 5),
                  child: Icon(Icons.videogame_asset, size: 20, color: Colors.cyan,)
              ),
              ),
              TextSpan(
                text: categoryName,
                style: TextStyle(
                    height: 2.5,
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )
    );
  }
}

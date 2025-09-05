import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:social_share_plugin/social_share_plugin.dart' as SocialSharePlugin;
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
// import 'package:ktg_news_app/models/article.dart'; // trùng -> bỏ
import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

/// Biến global (đã type + nullable)
List<dynamic>? newsListRelated;
List<dynamic>? newsListHot;
List<dynamic>? _newsDetail;

/// ---------------- Related News ----------------
class RelatedNewsByCat extends StatefulWidget {
  const RelatedNewsByCat({super.key});

  @override
  State<RelatedNewsByCat> createState() => _RelatedNewsByCatState();
}

class _RelatedNewsByCatState extends State<RelatedNewsByCat> {
  @override
  Widget build(BuildContext context) {
    if (newsListRelated == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: ListView.builder(
        itemCount: newsListRelated!.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final n = newsListRelated![index];
          return NewsTile(
            imgUrl: n.urlToImage ?? "",
            title: n.title ?? "",
            desc: n.description ?? "",
            posturl: n.articleUrl ?? "",
            categoryCatName: n.categoryCatName ?? "",
            publshedAt: (n.publshedAt ?? '').toString(),
            catNameKey: (n.catNameKey ?? '').toString(),
            gameNewsKey: (n.gameNewsKey ?? '').toString(),
            id: (n.id ?? '').toString(),
            newsCatId: (n.newsCatId ?? '').toString(),
            newsSource: (n.newsSource ?? '').toString(),
          );
        },
      ),
    );
  }
}

/// ---------------- Hot News ----------------
class HotNewsByCat extends StatefulWidget {
  const HotNewsByCat({super.key});

  @override
  State<HotNewsByCat> createState() => _HotNewsByCatState();
}

class _HotNewsByCatState extends State<HotNewsByCat> {
  @override
  Widget build(BuildContext context) {
    if (newsListHot == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: ListView.builder(
        itemCount: newsListHot!.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final n = newsListHot![index];
          return NewsTile(
            imgUrl: n.urlToImage ?? "",
            title: n.title ?? "",
            desc: n.description ?? "",
            posturl: n.articleUrl ?? "",
            categoryCatName: n.categoryCatName ?? "",
            publshedAt: (n.publshedAt ?? '').toString(),
            catNameKey: (n.catNameKey ?? '').toString(),
            gameNewsKey: (n.gameNewsKey ?? '').toString(),
            id: (n.id ?? '').toString(),
            newsCatId: (n.newsCatId ?? '').toString(),
            newsSource: (n.newsSource ?? '').toString(),
          );
        },
      ),
    );
  }
}

/// ---------------- News Detail list (HTML content blocks) ----------------
class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key});

  @override
  State<NewsDetail> createState() => _NewsDetailState();

  // giữ stub cho compiles cũ (không dùng ở đây)
  void getNewsDetail(
      String catNameKey, String pageNo, String s, String t, String u, String id) {}
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext bcontext) {
    if (_newsDetail == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: ListView.builder(
        itemCount: _newsDetail!.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final content = _newsDetail![index].content ?? "";
          return Html(
            data: content,
            // onLinkTap: (url, context, attributes, element) {
            //   if (url == null || url.isEmpty) return;
            //   showAlertDialog(bcontext, url);
            // },
          );
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context, String url) {
    final cancelButton = TextButton(
      child: const Text("Hủy bỏ"),
      onPressed: () => Navigator.of(context).pop(),
    );
    final continueButton = TextButton(
      child: const Text("Tiếp tục"),
      onPressed: () async {
        await launchUrl(Uri.parse(url));
        if (context.mounted) Navigator.of(context).pop();
      },
    );

    final alert = AlertDialog(
      title: const Text("Thông Báo"),
      content: Text("Bạn có thật sự muốn truy cập liên kết: $url ?"),
      actions: [cancelButton, continueButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

/// ---------------- Article View (detail page) ----------------
class ArticleView extends StatefulWidget {
  const ArticleView({
    super.key,
    this.urlToImage,
    this.title,
    this.desc,
    this.postUrl,
    this.categoryCatName,
    this.publshedAt,
    this.catNameKey,
    this.gameNewsKey,
    this.id,
    this.newsCatId,
    this.newsSource,
  });

  final String? urlToImage;
  final String? title;
  final String? desc;
  final String? postUrl;
  final String? categoryCatName;
  final String? publshedAt;
  final String? catNameKey;
  final String? gameNewsKey;
  final String? id;
  final String? newsCatId;
  final String? newsSource;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> with TickerProviderStateMixin {
  // Ads
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      // ignore: avoid_print
      print('Unable to get height of anchored banner.');
      return;
    }

    final adUnitId = dotenv.env['GOOGLE_ADMOD_BANNER_ID'] ?? '';
    if (adUnitId.isEmpty) {
      // ignore: avoid_print
      print('Missing GOOGLE_ADMOD_BANNER_ID in .env');
      return;
    }

    final banner = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // ignore: avoid_print
          print('$ad loaded: ${(ad as BannerAd).responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // ignore: avoid_print
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await banner.load();
  }

  bool _visible = false;
  BottomLoader? bl;
  late final ScrollController _scrollController;

  void _scrollListener() {}

  // --- Fetch detail / related / hot ---
  Future<void> getNewsDetail(String catNameKey, String pageNo) async {
    _visible = false;
    EasyLoading.show(status: 'Đang tải...');

    final newsDetailProcess = NewsDetailProcess();
    await newsDetailProcess.getNewsDetail(
      catNameKey,
      pageNo,
      '5',
      'false',
      'true',
      widget.id ?? '',
    );
    _newsDetail = newsDetailProcess.newsDetail;

    setState(() {
      _visible = true;
      EasyLoading.dismiss();
    });
  }

  Future<void> getNewsRelated(String catNameKey, String pageNo) async {
    _visible = false;
    final news = News();
    await news.getNews(catNameKey, pageNo, '5', 'false', 'true', widget.id ?? '');
    newsListRelated = news.news;
    setState(() => _visible = true);
  }

  Future<void> getNewsHot(String catNameKey, String pageNo) async {
    _visible = false;
    final news = News();
    await news.getNews(catNameKey, pageNo, '5', 'true', 'false', widget.id ?? '');
    newsListHot = news.news;
    setState(() => _visible = true);
  }

  void showAlertDialog(BuildContext context, String url) {
    final cancelButton = TextButton(
      child: const Text("Hủy bỏ"),
      onPressed: () => Navigator.of(context).pop(),
    );
    final continueButton = TextButton(
      child: const Text("Tiếp tục"),
      onPressed: () async {
        await launchUrl(Uri.parse(url));
        if (context.mounted) Navigator.of(context).pop();
      },
    );

    final alert = AlertDialog(
      title: const Text("Thông Báo"),
      content: Text("Bạn có thật sự muốn truy cập liên kết: $url ?"),
      actions: [cancelButton, continueButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  Html DescContentProcess(String desc, int newsCatId) {
    return Html(
      data:
      "<span style='font-size: 18px; font-style: italic;'><b>${widget.desc ?? ''}</b></span>",
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      1,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);

    // Lấy catNameKey an toàn
    final catKey = (widget.catNameKey?.isNotEmpty ?? false)
        ? widget.catNameKey!
        : '0';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNewsDetail(catKey, '1');
      getNewsRelated(catKey, '1');
      getNewsHot(catKey, '1');
    });
  }

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext bcontext) {
    bl ??= BottomLoader(context)
      ..style(
        message: 'Đang tải tin tức...',
        backgroundColor: Colors.white,
        messageTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
      );

    final parsedDateText = () {
      final s = widget.publshedAt;
      if (s == null || s.isEmpty) return '';
      try {
        final dt = DateTime.parse(s);
        return DateFormat('dd-MM-yyyy HH:mm:ss').format(dt);
      } catch (_) {
        return s; // fallback hiển thị raw
      }
    }();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.categoryCatName ?? '',
              style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            icon: const Icon(Icons.share),
            highlightColor: Colors.pink,
            onPressed: () async {
              await SocialSharePlugin.shareToFeedFacebookLink(
                quote: 'Kênh Tin Game - ${widget.categoryCatName ?? ''}',
                url:
                'https://kenhtingame.com/${widget.catNameKey ?? '0'}/1',
              );
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
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Html(data: "<h2>${widget.title ?? ''}</h2>"),
                    Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 5),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(Icons.calendar_today),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              parsedDateText,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () async {
                              await SocialSharePlugin.shareToFeedFacebookLink(
                                quote: widget.desc ?? '',
                                url:
                                'https://kenhtingame.com/${widget.catNameKey ?? '0'}/${widget.gameNewsKey ?? ''}/${widget.id ?? ''}',
                              );
                            },
                          ),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              await SocialSharePlugin.shareToTwitterLink(
                                text: widget.desc ?? '',
                                url:
                                'https://kenhtingame.com/${widget.catNameKey ?? '0'}/${widget.gameNewsKey ?? ''}/${widget.id ?? ''}',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    DescContentProcess(
                      "<span style='font-size: 18px; font-style: italic;'><b>${widget.desc ?? ''}</b></span>",
                      int.tryParse(widget.newsCatId ?? '0') ?? 0,
                    ),
                    const NewsDetail(),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      height: 1580,
                      child: ContainedTabBarView(
                        tabs: const [
                          Text(
                            'CÙNG CHUYÊN MỤC',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'HOT TRONG NGÀY',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                        tabBarProperties: TabBarProperties(
                          height: 30.0,
                          indicatorColor: Colors.black,
                          indicatorWeight: 3.0,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                        ),
                        views: const [
                          RelatedNewsByCat(),
                          HotNewsByCat(),
                        ],
                        onChange: (index) => debugPrint('Tab: $index'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_anchoredAdaptiveAd != null && _isLoaded)
            Container(
              color: Colors.green,
              width: _anchoredAdaptiveAd!.size.width.toDouble(),
              height: _anchoredAdaptiveAd!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredAdaptiveAd!),
            ),
        ],
      ),
    );
  }
}

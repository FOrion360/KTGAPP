import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ktg_news_app/helper/news.dart';
import 'package:ktg_news_app/helper/widgets.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({
    super.key,
    required this.newsCategory,
    required this.categoryCatName,
  });

  final String newsCategory;
  final String categoryCatName;

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  // Ads
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Lấy kích thước banner adaptive theo orientation hiện tại
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      // ignore: avoid_print
      print('Unable to get height of anchored banner.');
      return;
    }

    // Đọc adUnit từ .env (khuyến nghị 2 key khác nhau cho Android/iOS nếu cần)
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

  // Scroll & load more
  late final ScrollController _scrollController;
  int _pageNo = 1;
  BottomLoader? bl;
  bool _showBackToTopButton = false;

  List<dynamic> newslist = [];
  bool _loading = true;

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo++;
        bl?.display();
        getNews();
      });
    }
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo = 1;
        getNews();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
  }

  // Back to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    getNews();
  }

  Future<void> getNews() async {
    final news = NewsForCategorie();
    await news.getNewsForCategory(
      widget.newsCategory,
      _pageNo.toString(),
      '10',
      'false',
      'false',
      '0',
    );

    if (newslist.isNotEmpty && _pageNo != 1) {
      newslist.addAll(news.news); // Gộp danh sách đúng cách
    } else {
      newslist = List<dynamic>.from(news.news);
    }

    setState(() {
      bl?.hide();
      _loading = false;
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  Future<void> getNewsMenu(String newsCategory, String pageNo) async {
    final news = NewsForCategorie();
    await news.getNewsForCategory(
      newsCategory,
      pageNo,
      '10',
      'false',
      'false',
      '0',
    );

    if (newslist.isNotEmpty && _pageNo != 1) {
      newslist.addAll(news.news);
    } else {
      newslist = List<dynamic>.from(news.news);
    }

    setState(() {
      bl?.hide();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bl ??= BottomLoader(context)
      ..style(
        message: 'Đang tải thêm tin tức...',
        backgroundColor: Colors.white,
        messageTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Kênh Tin ",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600)),
            Text("Game",
                style:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: const [
          Opacity(
            opacity: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.share),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: _BackToTopButton(),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: newslist.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final n = newslist[index];
                  return NewsTile(
                    imgUrl: n.urlToImage ?? "",
                    title: n.title ?? "",
                    desc: n.description ?? "",
                    posturl: n.articleUrl ?? "",
                    categoryCatName: n.categoryCatName ?? "",
                    // Giữ tên field gốc nếu model dùng 'publshedAt'
                    publshedAt: (n.publshedAt ?? '').toString(),
                    catNameKey: (n.catNameKey ?? '').toString(),
                    gameNewsKey: (n.gameNewsKey ?? '').toString(),
                    id: (n.id ?? '').toString(),
                    newsCatId: (n.newsCatId ?? '').toString(),
                    newsSource: (n.newsSource ?? '').toString(),
                  );
                },
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

class _BackToTopButton extends StatelessWidget {
  const _BackToTopButton();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_CategoryNewsState>();
    return FloatingActionButton(
      onPressed: state?._scrollToTop,
      child: const Icon(Icons.arrow_upward),
    );
  }
}

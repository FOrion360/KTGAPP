import 'dart:io' show Platform;

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
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// -------------------- NAV DRAWER --------------------
class NavDrawer extends StatelessWidget {
  NavDrawer({super.key});

  final List<CategorieModel> categories = getCategories();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.black87,
              image: DecorationImage(
                image: AssetImage('assets/ktglogo.png'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 450,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryNav(
                  imageAssetUrl: categories[index].imageAssetUrl,
                  categoryName: categories[index].categorieName,
                  categoryCatName: categories[index].categorieCatName,
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Liên hệ hợp tác & Quảng cáo'),
            visualDensity: const VisualDensity(vertical: -4),
            onTap: () async {
              await launchUrl(_emailContactLaunchUri);
            },
          ),
          ListTile(
            leading: const Icon(Icons.error),
            title: const Text('Báo lỗi ứng dụng'),
            visualDensity: const VisualDensity(vertical: -4),
            onTap: () async {
              await launchUrl(_emailErrorReportLaunchUri);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            height: 90,
            color: Colors.black87,
            child: Html(
              data: '<div style="color: white; font-weight: bold;">Thông Tin Liên Hệ Kênh Tin Game</div>'
                  '<div style="color: white;">- Chịu trách nhiệm nội dung: Đặng Thị Bé</div>'
                  '<div style="color: white;">- Email: kenhtingame@gmail.com</div>'
                  '<div style="color: white;">- Điện thoại: 0394023734</div>',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            height: 25,
            color: Colors.black87,
            child: Center(
              child: Text(
                '© 2017 - ${DateTime.now().year} KTGame - Version 1.1.0',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final Uri _emailContactLaunchUri = Uri(
    scheme: 'mailto',
    path: 'kenhtingame@gmail.com',
    queryParameters: {'subject': '[KTG APP] Liên hệ hợp tác & Quảng cáo'},
  );

  static final Uri _emailErrorReportLaunchUri = Uri(
    scheme: 'mailto',
    path: 'kenhtingame@gmail.com',
    queryParameters: {'subject': '[KTG APP] Báo lỗi ứng dụng'},
  );

  void showAlertDialog(BuildContext context, String title, String messContent) {
    // ignore: unused_local_variable
    final okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    final alert = AlertDialog(
      title: Text(title),
      content: Text(messContent),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

/// -------------------- HOME PAGE --------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  late final ScrollController _scrollController;
  String message = "";
  int _pageNo = 1;
  BottomLoader? bl;
  bool _showBackToTopButton = false;

  bool _loading = true;
  List<dynamic> newslist = [];

  List<CategorieModel> categories = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    categories = getCategories();
    getNews('0', '1');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Lấy kích thước adaptive
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

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo++;
        bl?.display();
        getNews("0", _pageNo.toString());
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageNo = 1;
        getNews("0", _pageNo.toString());
      });
    }
  }

  Future<void> getNews(String catNameKey, String pageNo) async {
    final news = News();
    await news.getNews(catNameKey, pageNo, '10', 'false', 'false', '0');

    if (newslist.isNotEmpty && _pageNo != 1) {
      // Gộp danh sách đúng cách
      newslist.addAll(news.news);
    } else {
      newslist = List<dynamic>.from(news.news);
    }

    setState(() {
      bl?.hide();
      _loading = false;
    });
  }

  // Nút back-to-top
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _anchoredAdaptiveAd?.dispose();
    super.dispose();
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
      drawer: NavDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(), // giữ nguyên widget cũ
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: <Widget>[
            // Expanded danh sách bài viết
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
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
                      desc: removeAllHtmlTags(n.description ?? ""),
                      posturl: n.articleUrl ?? "",
                      categoryCatName: n.categoryCatName ?? "",
                      // Giữ nguyên field gốc nếu model đang dùng 'publshedAt'
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
      ),
    );
  }
}

/// -------------------- UTILS & WIDGETS --------------------
void showAlertDialog(BuildContext context, String title, String messContent) {
  final okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.of(context).pop(),
  );

  final alert = AlertDialog(
    title: Text(title),
    content: Text(messContent),
    actions: [okButton],
  );

  showDialog(context: context, builder: (_) => alert);
}

String removeAllHtmlTags(String? htmlText) {
  if (htmlText == null || htmlText.isEmpty) return '';
  final exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

/// Card danh mục trên màn hình chính
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.imageAssetUrl,
    required this.categoryName,
    required this.categoryCatName,
    this.pageNo,
  });

  final String imageAssetUrl;
  final String categoryName;
  final String categoryCatName;
  final String? pageNo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CategoryNews(
            newsCategory: categoryCatName.toLowerCase(),
            categoryCatName: categoryName,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 14),
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
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item danh mục trong Drawer
class CategoryNav extends StatelessWidget {
  const CategoryNav({
    super.key,
    required this.imageAssetUrl,
    required this.categoryName,
    required this.categoryCatName,
    this.pageNo,
  });

  final String imageAssetUrl;
  final String categoryName;
  final String categoryCatName;
  final String? pageNo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CategoryNews(
            newsCategory: categoryCatName.toLowerCase(),
            categoryCatName: categoryName,
          ),
        ));
      },
      child: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(left: 0, right: 5),
                child: Icon(Icons.videogame_asset, size: 20, color: Colors.cyan),
              ),
            ),
            TextSpan(
              text: categoryName,
              style: const TextStyle(
                height: 2.5,
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

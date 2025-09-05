import 'package:ktg_news_app/models/categorie_model.dart';

List<CategorieModel> getCategories(){

  List<CategorieModel> myCategories = List<CategorieModel>();
  CategorieModel categorieModel;

  //1
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "GAME MOBILE";
  categorieModel.categorieCatName = "mobile";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //2
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "GAME ONLINE";
  categorieModel.categorieCatName = "game-online";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //3
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "ESPORT";
  categorieModel.categorieCatName = "esport";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //4
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "PC/CONSOLE";
  categorieModel.categorieCatName = "pc-console";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //5
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "CÔNG NGHỆ";
  categorieModel.categorieCatName = "gaming-gear";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //5
  categorieModel = new CategorieModel();
  categorieModel.categorieName = "MANGA/FILM";
  categorieModel.categorieCatName = "manga-film";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  //5
  // categorieModel = new CategorieModel();
  // categorieModel.categorieName = "COSPLAY";
  // categorieModel.categorieCatName = "cosplay";
  // categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  // myCategories.add(categorieModel);

  categorieModel = new CategorieModel();
  categorieModel.categorieName = "KHÁM PHÁ";
  categorieModel.categorieCatName = "kham-pha";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  categorieModel = new CategorieModel();
  categorieModel.categorieName = "CỘNG ĐỒNG";
  categorieModel.categorieCatName = "cong-dong";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  categorieModel = new CategorieModel();
  categorieModel.categorieName = "GIẢI TRÍ";
  categorieModel.categorieCatName = "giai-tri";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  categorieModel = new CategorieModel();
  categorieModel.categorieName = "HOT TRONG NGÀY";
  categorieModel.categorieCatName = "all";
  categorieModel.imageAssetUrl = "https://kenhtingame.com/app_img/mobile_menu_top_bg.jpg";
  myCategories.add(categorieModel);

  return myCategories;

}
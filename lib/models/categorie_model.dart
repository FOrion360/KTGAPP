class CategorieModel {
  final String imageAssetUrl;
  final String categorieName;
  final String categorieCatName;

  const CategorieModel({
    required this.imageAssetUrl,
    required this.categorieName,
    required this.categorieCatName,
  });

  // (tuỳ chọn) fromMap / toMap nếu bạn load từ JSON
  factory CategorieModel.fromMap(Map<String, dynamic> map) => CategorieModel(
    imageAssetUrl: (map['imageAssetUrl'] ?? '') as String,
    categorieName: (map['categorieName'] ?? '') as String,
    categorieCatName: (map['categorieCatName'] ?? '') as String,
  );

  Map<String, dynamic> toMap() => {
    'imageAssetUrl': imageAssetUrl,
    'categorieName': categorieName,
    'categorieCatName': categorieCatName,
  };

  // (tuỳ chọn) copyWith để dễ cập nhật
  CategorieModel copyWith({
    String? imageAssetUrl,
    String? categorieName,
    String? categorieCatName,
  }) {
    return CategorieModel(
      imageAssetUrl: imageAssetUrl ?? this.imageAssetUrl,
      categorieName: categorieName ?? this.categorieName,
      categorieCatName: categorieCatName ?? this.categorieCatName,
    );
  }
}

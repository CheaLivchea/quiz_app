class HomeData {
  final List<Category> categories;
  final List<Banner> banners;
  final List<Promotion> promotions;

  HomeData({
    required this.categories,
    required this.banners,
    required this.promotions,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
      banners: (json['banners'] as List)
          .map((banner) => Banner.fromJson(banner))
          .toList(),
      promotions: (json['promotions'] as List)
          .map((promotion) => Promotion.fromJson(promotion))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String iconUrl;
  final String nameEn;
  final String nameZh;
  final String nameKh;

  Category({
    required this.id,
    required this.iconUrl,
    required this.nameEn,
    required this.nameZh,
    required this.nameKh,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      iconUrl: json['iconUrl'],
      nameEn: json['nameEn'],
      nameZh: json['nameZh'],
      nameKh: json['nameKh'],
    );
  }

  // Helper method to get name based on locale
  String getName(String locale) {
    switch (locale) {
      case 'zh':
        return nameZh;
      case 'kh':
        return nameKh;
      default:
        return nameEn;
    }
  }
}

class Banner {
  final int id;
  final String imgUrlEn;

  Banner({required this.id, required this.imgUrlEn});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(id: json['id'], imgUrlEn: json['imgUrlEn']);
  }
}

class Promotion {
  final int id;
  final String imgUrlEn;

  Promotion({required this.id, required this.imgUrlEn});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(id: json['id'], imgUrlEn: json['imgUrlEn']);
  }
}

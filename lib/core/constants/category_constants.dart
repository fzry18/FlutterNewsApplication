import 'package:news_app/domain/entities/category.dart';

class CategoryConstants {
  static const List<Category> categories = [
    Category(id: 'general', name: 'Umum', icon: 'assets/icons/general.png'),
    Category(id: 'business', name: 'Bisnis', icon: 'assets/icons/business.png'),
    Category(
      id: 'entertainment',
      name: 'Hiburan',
      icon: 'assets/icons/entertainment.png',
    ),
    Category(id: 'health', name: 'Kesehatan', icon: 'assets/icons/health.png'),
    Category(id: 'science', name: 'Sains', icon: 'assets/icons/science.png'),
    Category(id: 'sports', name: 'Olahraga', icon: 'assets/icons/sports.png'),
    Category(
      id: 'technology',
      name: 'Teknologi',
      icon: 'assets/icons/technology.png',
    ),
  ];
}

# News App

A modern Flutter application for reading the latest news from various trusted sources, with a beautiful and responsive UI.

## ✨ Features

- **Latest News**: Get up-to-date news headlines from multiple sources.
- **Category Filter**: Browse news by categories such as General, Business, Entertainment, Health, Science, Sports, and Technology.
- **Search**: Find news articles by keywords.
- **Favorites**: Save your favorite articles for offline reading.
- **Article Details**: Read full articles with images, author, and publication date.
- **Responsive Design**: Optimized for all screen sizes.
- **Smooth Animations**: Enjoy smooth transitions and interactive UI elements.
- **Scroll-to-Top**: Quickly return to the top of the news list.

## 📱 Screenshots

<!-- Replace with your own screenshots -->
| Home | Categories | Search | Details | Favorites |
|------|------------|--------|---------|-----------|
| ![](https://via.placeholder.com/180x380/0078D7/ffffff?text=Home) | ![](https://via.placeholder.com/180x380/0078D7/ffffff?text=Categories) | ![](https://via.placeholder.com/180x380/0078D7/ffffff?text=Search) | ![](https://via.placeholder.com/180x380/0078D7/ffffff?text=Details) | ![](https://via.placeholder.com/180x380/0078D7/ffffff?text=Favorites) |

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0.0 or newer
- Dart 2.17.0 or newer
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)
- [News API](https://newsapi.org/) key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/news_app.git
   cd news_app
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Configure API Key**
   - Create a `.env` file in the project root and add your News API key:
     ```
     NEWS_API_KEY=your_api_key_here
     ```
4. **Run the app**
   ```bash
   flutter run
   ```

## 🧭 Usage Guide

### Browsing News
- Open the app to see the latest headlines.
- Pull down to refresh the news list.
- Tap the scroll-to-top button to quickly return to the top.

### Filtering by Category
- Swipe the category bar at the top.
- Tap a category to filter news articles.

### Searching News
- Tap the search bar at the top.
- Enter a keyword and press search.
- View the search results instantly.

### Saving Favorites
- Tap the heart icon on any article to add it to your favorites.
- Access your saved articles from the Favorites tab.

### Reading Article Details
- Tap any article to view its details.
- Read the full content and tap "Read Full Article" to open the original source.

## 📂 Project Structure

```
lib/
├── core/           # Core utilities and constants
├── data/           # Data sources, models, repositories
├── di/             # Dependency injection setup
├── domain/         # Entities, repositories, use cases
├── presentation/   # UI: blocs, pages, widgets
└── main.dart       # App entry point
```

## 📦 Dependencies
- flutter_bloc
- get_it
- hive_flutter
- http
- cached_network_image
- flutter_screenutil
- intl
- url_launcher
- shimmer
- flutter_svg

## 🔗 API Reference
- [News API](https://newsapi.org/)

## 💡 Roadmap
- [ ] Dark mode support
- [ ] Article sharing
- [ ] Push notifications
- [ ] Source filtering
- [ ] Improved offline support
- [ ] Personalized news recommendations

## 🤝 Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

## 📄 License
This project is licensed under the MIT License.

## 📬 Contact
Developer: [@Muhammad Fazry Suhada](https://www.linkedin.com/in/muhammad-fazry-suhada/)  
Email: fazrysuhada168@gmail.com

Project Link: [https://github.com/FlutterNewsApplication/news_app](https://github.com/FlutterNewsApplication/news_app)

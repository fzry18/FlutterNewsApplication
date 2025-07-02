import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/blocs/news/news_bloc.dart';
import 'package:news_app/presentation/blocs/news/news_event.dart';
import 'package:news_app/presentation/blocs/news/news_state.dart';
import 'package:news_app/presentation/pages/favorites_page.dart';
import 'package:news_app/presentation/widgets/article_list_item.dart';
import 'package:news_app/presentation/widgets/category_selector.dart';
import 'package:news_app/presentation/widgets/loading_indicator.dart';
import 'package:news_app/presentation/widgets/custom_search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _showScrollToTop = false;
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fetch news headlines when the page loads
    BlocProvider.of<NewsBloc>(context).add(const GetHeadlinesEvent());
  }

  void _onScroll() {
    if (_scrollController.offset >= 300 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
      _fabAnimController.forward();
    } else if (_scrollController.offset < 300 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
      _fabAnimController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            const CustomSearchBar(),

            // Category Selector
            const CategorySelector(),

            // News List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<NewsBloc>(
                    context,
                  ).add(const RefreshHeadlinesEvent());
                },
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const LoadingIndicator();
                    } else if (state is NewsLoaded) {
                      return ListView.builder(
                        key: ValueKey<int>(state.articles.length),
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 20.h),
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          // Tampilan normal tanpa efek opacity yang berlebihan
                          return ArticleListItem(
                            article: state.articles[index],
                          );
                        },
                      );
                    } else if (state is NewsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 60.sp, color: Colors.red),
                            SizedBox(height: 16.h),
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(fontSize: 16.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<NewsBloc>(
                                  context,
                                ).add(const GetHeadlinesEvent());
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabAnimController,
          curve: Curves.easeOut,
        ),
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
            );
          },
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FavoritesPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          }
        },
      ),
    );
  }
}

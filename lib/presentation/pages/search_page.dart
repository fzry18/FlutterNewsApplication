// filepath: d:\kodingan\flutter-project\news_app\lib\presentation\pages\search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/blocs/search/search_bloc.dart';
import 'package:news_app/presentation/blocs/search/search_event.dart';
import 'package:news_app/presentation/blocs/search/search_state.dart';
import 'package:news_app/presentation/widgets/article_list_item.dart';
import 'package:news_app/presentation/widgets/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(23.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 22.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText: 'Search news...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16.sp,
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (query) {
                              if (query.isNotEmpty) {
                                BlocProvider.of<SearchBloc>(
                                  context,
                                ).add(SearchNewsEvent(query));
                              }
                            },
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[500],
                              size: 20.sp,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              BlocProvider.of<SearchBloc>(
                                context,
                              ).add(ClearSearchEvent());
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    'Search for news',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                  ),
                ],
              ),
            );
          } else if (state is SearchLoading) {
            return const LoadingIndicator();
          } else if (state is SearchLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No results found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                return ArticleListItem(
                  article: state.articles[index],
                  showSourceLogo: true,
                );
              },
            );
          } else if (state is SearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 80.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        BlocProvider.of<SearchBloc>(
                          context,
                        ).add(SearchNewsEvent(query));
                      }
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_event.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_state.dart';
import 'package:news_app/presentation/widgets/article_list_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        buildWhen: (previous, current) {
          // Hanya rebuild untuk state yang relevan untuk halaman favorites
          // Abaikan ArticleFavoriteStatus yang hanya untuk button individual
          return current is! ArticleFavoriteStatus;
        },
        builder: (context, state) {
          print(
            'Debug: Building FavoritesPage dengan state: ${state.runtimeType}',
          );

          if (state is FavoritesLoaded) {
            print(
              'Debug: FavoritesLoaded dengan ${state.favorites.length} artikel',
            );
            for (int i = 0; i < state.favorites.length; i++) {
              print('Debug: Artikel ${i + 1}: ${state.favorites[i].title}');
            }
          }

          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Articles you favorite will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FavoritesBloc>().add(LoadFavoritesEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  print(
                    'Debug: Rendering artikel ${index + 1}: ${state.favorites[index].title}',
                  );
                  return ArticleListItem(article: state.favorites[index]);
                },
              ),
            );
          } else if (state is FavoriteToggleSuccess) {
            // Untuk sementara tampilkan loading saat toggle success
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesError) {
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
                      context.read<FavoritesBloc>().add(LoadFavoritesEvent());
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

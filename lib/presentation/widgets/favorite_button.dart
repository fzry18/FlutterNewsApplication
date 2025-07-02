import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_event.dart';
import 'package:news_app/presentation/blocs/favorites/favorites_state.dart';

class FavoriteButton extends StatefulWidget {
  final Article article;

  const FavoriteButton({Key? key, required this.article}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check favorite status when widget is initialized
    context.read<FavoritesBloc>().add(
      CheckFavoriteStatusEvent(widget.article.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is ArticleFavoriteStatus &&
            state.articleId == widget.article.id) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        } else if (state is FavoriteToggleSuccess &&
            state.article.id == widget.article.id) {
          setState(() {
            _isFavorite = state.isFavorite;
          });
        }
      },
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<FavoritesBloc>().add(
              ToggleFavoriteEvent(widget.article),
            );
          },
        );
      },
    );
  }
}

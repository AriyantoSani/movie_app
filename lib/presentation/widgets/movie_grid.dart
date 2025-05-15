import 'package:flutter/material.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/presentation/widgets/movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;
  final VoidCallback? onLoadMore;
  final bool isLoading;

  const MovieGrid({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.onLoadMore,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            onLoadMore != null &&
            !isLoading) {
          onLoadMore!();
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: movies.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= movies.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () => onMovieTap(movie),
          );
        },
      ),
    );
  }
}

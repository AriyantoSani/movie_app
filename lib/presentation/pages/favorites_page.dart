import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/presentation/controllers/favorites_controller.dart';
import 'package:movie_app/presentation/widgets/movie_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadFavoriteMovies,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.favoriteMovies.isEmpty) {
          return const Center(
            child: Text(
              'No favorite movies yet',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavoriteMovies,
          child: MovieGrid(
            movies: controller.favoriteMovies,
            onMovieTap: (movie) {
              Get.toNamed('${RouterConstants.movieDetail}/${movie.id}')?.then((_) {
                controller.loadFavoriteMovies();
              });
            },
          ),
        );
      }),
    );
  }
}

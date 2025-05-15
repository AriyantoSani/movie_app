import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/presentation/controllers/movie_list_controller.dart';
import 'package:movie_app/presentation/widgets/movie_grid.dart';
import 'package:movie_app/presentation/widgets/search_bar_widget.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed(RouterConstants.favorites),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) => controller.search(query),
            onClear: () => controller.search(''),
          ),
          Expanded(
            child: Obx(() {
              if (controller.movies.isEmpty && controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.movies.isEmpty && controller.errorMessage.isNotEmpty) {
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
                        onPressed: controller.refreshMovies,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.movies.isEmpty) {
                return const Center(
                  child: Text('No movies found'),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshMovies,
                child: MovieGrid(
                  movies: controller.movies,
                  onMovieTap: (movie) => Get.toNamed('${RouterConstants.movieDetail}/${movie.id}'),
                  onLoadMore: controller.isSearching.value ? null : controller.fetchMovies,
                  isLoading: controller.isLoading.value,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

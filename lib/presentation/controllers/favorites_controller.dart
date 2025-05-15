import 'package:get/get.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/get_favorite_movies.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';

class FavoritesController extends GetxController {
  final GetFavoriteMovies getFavoriteMovies;
  final RemoveMovieFromFavorites removeMovieFromFavorites;

  FavoritesController({
    required this.getFavoriteMovies,
    required this.removeMovieFromFavorites,
  });

  var favoriteMovies = <Movie>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteMovies();
  }

  Future<void> loadFavoriteMovies() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getFavoriteMovies();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (movies) {
        favoriteMovies.value = movies;
      },
    );

    isLoading.value = false;
  }

  Future<void> removeFromFavorites(int movieId) async {
    final result = await removeMovieFromFavorites(movieId);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) {
        favoriteMovies.removeWhere((movie) => movie.id == movieId);
      },
    );
  }
}

import 'package:get/get.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/add_movie_to_favorites.dart';
import 'package:movie_app/domain/usecases/get_movie_details.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';

class MovieDetailController extends GetxController {
  final GetMovieDetails getMovieDetails;
  final AddMovieToFavorites addMovieToFavorites;
  final RemoveMovieFromFavorites removeMovieFromFavorites;

  MovieDetailController({
    required this.getMovieDetails,
    required this.addMovieToFavorites,
    required this.removeMovieFromFavorites,
  });

  var movie = Rx<Movie?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadMovieDetails(int movieId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getMovieDetails(movieId);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (movieData) {
        movie.value = movieData;
      },
    );

    isLoading.value = false;
  }

  Future<void> toggleFavorite() async {
    if (movie.value == null) return;

    final currentMovie = movie.value!;
    
    if (currentMovie.isFavorite) {
      final result = await removeMovieFromFavorites(currentMovie.id);
      
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          movie.value = currentMovie.copyWith(isFavorite: false);
        },
      );
    } else {
      final result = await addMovieToFavorites(currentMovie);
      
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
        },
        (_) {
          movie.value = currentMovie.copyWith(isFavorite: true);
        },
      );
    }
  }
}

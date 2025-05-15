import 'package:hive/hive.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getFavoriteMovies();
  Future<void> addMovieToFavorites(MovieModel movie);
  Future<void> removeMovieFromFavorites(int movieId);
  Future<bool> isMovieFavorite(int movieId);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box<Map> movieBox;

  MovieLocalDataSourceImpl({required this.movieBox});

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    final favoriteMoviesMap = movieBox.get(
      AppConstants.favoriteMoviesKey,
      defaultValue: <String, dynamic>{},
    ) as Map;

    final List<MovieModel> favoriteMovies = [];

    favoriteMoviesMap.forEach((key, value) {
      favoriteMovies.add(MovieModel.fromJson(Map<String, dynamic>.from(value)));
    });

    return favoriteMovies;
  }

  @override
  Future<void> addMovieToFavorites(MovieModel movie) async {
    final favoriteMoviesMap = movieBox.get(
      AppConstants.favoriteMoviesKey,
      defaultValue: <String, dynamic>{},
    ) as Map;

    final updatedMovie =
        MovieModel.fromEntity(movie.copyWith(isFavorite: true));
    favoriteMoviesMap[movie.id.toString()] = updatedMovie.toJson();

    await movieBox.put(AppConstants.favoriteMoviesKey, favoriteMoviesMap);
  }

  @override
  Future<void> removeMovieFromFavorites(int movieId) async {
    final favoriteMoviesMap = movieBox.get(
      AppConstants.favoriteMoviesKey,
      defaultValue: <String, dynamic>{},
    ) as Map;

    favoriteMoviesMap.remove(movieId.toString());

    await movieBox.put(AppConstants.favoriteMoviesKey, favoriteMoviesMap);
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final favoriteMoviesMap = movieBox.get(
      AppConstants.favoriteMoviesKey,
      defaultValue: <String, dynamic>{},
    ) as Map;

    return favoriteMoviesMap.containsKey(movieId.toString());
  }
}

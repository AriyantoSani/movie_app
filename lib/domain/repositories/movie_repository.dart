import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies(int page);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, Movie>> getMovieDetails(int id);
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
  Future<Either<Failure, void>> addMovieToFavorites(Movie movie);
  Future<Either<Failure, void>> removeMovieFromFavorites(int movieId);
}

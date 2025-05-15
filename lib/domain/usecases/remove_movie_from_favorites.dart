import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class RemoveMovieFromFavorites {
  final MovieRepository repository;

  RemoveMovieFromFavorites(this.repository);

  Future<Either<Failure, void>> call(int movieId) {
    return repository.removeMovieFromFavorites(movieId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class GetFavoriteMovies {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getFavoriteMovies();
  }
}

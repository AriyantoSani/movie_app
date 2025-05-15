import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class AddMovieToFavorites {
  final MovieRepository repository;

  AddMovieToFavorites(this.repository);

  Future<Either<Failure, void>> call(Movie movie) {
    return repository.addMovieToFavorites(movie);
  }
}

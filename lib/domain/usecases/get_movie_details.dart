import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<Either<Failure, Movie>> call(int id) {
    return repository.getMovieDetails(id);
  }
}

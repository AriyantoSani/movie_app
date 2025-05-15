import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class GetMovies {
  final MovieRepository repository;

  GetMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(int page) {
    return repository.getMovies(page);
  }
}

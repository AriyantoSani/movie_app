import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getMovies(int page) async {
    try {
      final movies = await remoteDataSource.getMovies(page);

      // Check if each movie is in favorites
      final List<Movie> moviesWithFavoriteStatus = [];
      for (var movie in movies) {
        final isFavorite = await localDataSource.isMovieFavorite(movie.id);
        moviesWithFavoriteStatus.add(movie.copyWith(isFavorite: isFavorite));
      }

      return Right(moviesWithFavoriteStatus);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);

      // Check if each movie is in favorites
      final List<Movie> moviesWithFavoriteStatus = [];
      for (var movie in movies) {
        final isFavorite = await localDataSource.isMovieFavorite(movie.id);
        moviesWithFavoriteStatus.add(movie.copyWith(isFavorite: isFavorite));
      }

      return Right(moviesWithFavoriteStatus);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int id) async {
    try {
      final movie = await remoteDataSource.getMovieDetails(id);
      final isFavorite = await localDataSource.isMovieFavorite(movie.id);

      return Right(movie.copyWith(isFavorite: isFavorite));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      final movies = await localDataSource.getFavoriteMovies();
      return Right(movies);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMovieToFavorites(Movie movie) async {
    try {
      await localDataSource.addMovieToFavorites(MovieModel.fromEntity(movie));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeMovieFromFavorites(int movieId) async {
    try {
      await localDataSource.removeMovieFromFavorites(movieId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

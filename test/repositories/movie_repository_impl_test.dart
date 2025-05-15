import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/core/error/exceptions.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/domain/entities/movie.dart';

import 'movie_repository_impl_test.mocks.dart';

@GenerateMocks([MovieRemoteDataSource, MovieLocalDataSource])
void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tMovieModel = MovieModel(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    voteAverage: 8.5,
    releaseDate: '2023-01-01',
    genreIds: [1, 2, 3],
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
  );

  final List<MovieModel> tMovieModels = [tMovieModel];
  final List<Movie> tMovies = tMovieModels;

  group('getMovies', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getMovies(any))
            .thenAnswer((_) async => tMovieModels);
        // act
        final result = await repository.getMovies(1);
        // assert
        verify(mockRemoteDataSource.getMovies(1));
        expect(result, equals(Right(tMovies)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getMovies(any))
            .thenThrow(ServerException('Server error'));
        // act
        final result = await repository.getMovies(1);
        // assert
        verify(mockRemoteDataSource.getMovies(1));
        expect(result, equals(Left(ServerFailure('Server error'))));
      },
    );
  });

  group('searchMovies', () {
    const tQuery = 'test';

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchMovies(any))
            .thenAnswer((_) async => tMovieModels);
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        verify(mockRemoteDataSource.searchMovies(tQuery));
        expect(result, equals(Right(tMovies)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchMovies(any))
            .thenThrow(ServerException('Server error'));
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        verify(mockRemoteDataSource.searchMovies(tQuery));
        expect(result, equals(Left(ServerFailure('Server error'))));
      },
    );
  });

  group('getMovieDetails', () {
    const tId = 1;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getMovieDetails(any))
            .thenAnswer((_) async => tMovieModel);
        // act
        final result = await repository.getMovieDetails(tId);
        // assert
        verify(mockRemoteDataSource.getMovieDetails(tId));
        expect(result, equals(Right(tMovieModel)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getMovieDetails(any))
            .thenThrow(ServerException('Server error'));
        // act
        final result = await repository.getMovieDetails(tId);
        // assert
        verify(mockRemoteDataSource.getMovieDetails(tId));
        expect(result, equals(Left(ServerFailure('Server error'))));
      },
    );
  });
}

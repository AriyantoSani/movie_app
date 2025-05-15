import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/add_movie_to_favorites.dart';
import 'package:movie_app/domain/usecases/get_movie_details.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';
import 'package:movie_app/presentation/controllers/movie_detail_controller.dart';

import 'movie_detail_controller_test.mocks.dart';

@GenerateMocks([GetMovieDetails, AddMovieToFavorites, RemoveMovieFromFavorites])
void main() {
  late MovieDetailController controller;
  late MockGetMovieDetails mockGetMovieDetails;
  late MockAddMovieToFavorites mockAddMovieToFavorites;
  late MockRemoveMovieFromFavorites mockRemoveMovieFromFavorites;

  setUp(() {
    mockGetMovieDetails = MockGetMovieDetails();
    mockAddMovieToFavorites = MockAddMovieToFavorites();
    mockRemoveMovieFromFavorites = MockRemoveMovieFromFavorites();
    controller = MovieDetailController(
      getMovieDetails: mockGetMovieDetails,
      addMovieToFavorites: mockAddMovieToFavorites,
      removeMovieFromFavorites: mockRemoveMovieFromFavorites,
    );
  });

  const tMovieId = 1;
  const tMovie = Movie(
    id: tMovieId,
    title: 'Test Movie',
    overview: 'Test Overview',
    voteAverage: 8.5,
    releaseDate: '2023-01-01',
    genreIds: [1, 2, 3],
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
  );

  group('loadMovieDetails', () {
    test(
      'should update movie when getMovieDetails returns success',
      () async {
        // arrange
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => const Right(tMovie));
        // act
        await controller.loadMovieDetails(tMovieId);
        // assert
        expect(controller.movie.value, tMovie);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, '');
        verify(mockGetMovieDetails(tMovieId));
      },
    );

    test(
      'should update errorMessage when getMovieDetails returns failure',
      () async {
        // arrange
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.loadMovieDetails(tMovieId);
        // assert
        expect(controller.movie.value, null);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, 'Server error');
        verify(mockGetMovieDetails(tMovieId));
      },
    );
  });

  group('toggleFavorite', () {
    test(
      'should add movie to favorites when movie is not favorite',
      () async {
        // arrange
        const nonFavoriteMovie = Movie(
          id: tMovieId,
          title: 'Test Movie',
          overview: 'Test Overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genreIds: [1, 2, 3],
          posterPath: '/test_poster.jpg',
          backdropPath: '/test_backdrop.jpg',
          isFavorite: false,
        );
        controller.movie.value = nonFavoriteMovie;
        when(mockAddMovieToFavorites(any)).thenAnswer(
          (_) async => const Right(
            unit,
          ),
        );
        // act
        await controller.toggleFavorite();
        // assert
        expect(controller.movie.value?.isFavorite, true);
        verify(mockAddMovieToFavorites(nonFavoriteMovie));
        verifyNever(mockRemoveMovieFromFavorites(any));
      },
    );

    test(
      'should remove movie from favorites when movie is favorite',
      () async {
        // arrange
        const favoriteMovie = Movie(
          id: tMovieId,
          title: 'Test Movie',
          overview: 'Test Overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genreIds: [1, 2, 3],
          posterPath: '/test_poster.jpg',
          backdropPath: '/test_backdrop.jpg',
          isFavorite: true,
        );
        controller.movie.value = favoriteMovie;
        when(mockRemoveMovieFromFavorites(any)).thenAnswer(
          (_) async => const Right(
            unit,
          ),
        );
        // act
        await controller.toggleFavorite();
        // assert
        expect(controller.movie.value?.isFavorite, false);
        verify(mockRemoveMovieFromFavorites(tMovieId));
        verifyNever(mockAddMovieToFavorites(any));
      },
    );

    test(
      'should return false and update errorMessage when addMovieToFavorites returns failure',
      () async {
        // arrange
        const nonFavoriteMovie = Movie(
          id: tMovieId,
          title: 'Test Movie',
          overview: 'Test Overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genreIds: [1, 2, 3],
          posterPath: '/test_poster.jpg',
          backdropPath: '/test_backdrop.jpg',
          isFavorite: false,
        );
        controller.movie.value = nonFavoriteMovie;
        when(mockAddMovieToFavorites(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.toggleFavorite();
        // assert
        expect(controller.movie.value?.isFavorite, false); // Unchanged
        expect(controller.errorMessage.value, 'Server error');
        verify(mockAddMovieToFavorites(nonFavoriteMovie));
      },
    );

    test(
      'should return false and update errorMessage when removeMovieFromFavorites returns failure',
      () async {
        // arrange
        const favoriteMovie = Movie(
          id: tMovieId,
          title: 'Test Movie',
          overview: 'Test Overview',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genreIds: [1, 2, 3],
          posterPath: '/test_poster.jpg',
          backdropPath: '/test_backdrop.jpg',
          isFavorite: true,
        );
        controller.movie.value = favoriteMovie;
        when(mockRemoveMovieFromFavorites(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.toggleFavorite();
        // assert
        expect(controller.movie.value?.isFavorite, true); // Unchanged
        expect(controller.errorMessage.value, 'Server error');
        verify(mockRemoveMovieFromFavorites(tMovieId));
      },
    );

    test(
      'should return false when movie is null',
      () async {
        // arrange
        controller.movie.value = null;
        // act
        await controller.toggleFavorite();
        // assert
        verifyNever(mockAddMovieToFavorites(any));
        verifyNever(mockRemoveMovieFromFavorites(any));
      },
    );
  });
}

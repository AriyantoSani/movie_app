import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/get_favorite_movies.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';
import 'package:movie_app/presentation/controllers/favorites_controller.dart';

import 'favorites_controller_test.mocks.dart';

@GenerateMocks([GetFavoriteMovies, RemoveMovieFromFavorites])
void main() {
  late FavoritesController controller;
  late MockGetFavoriteMovies mockGetFavoriteMovies;
  late MockRemoveMovieFromFavorites mockRemoveMovieFromFavorites;

  setUp(() {
    mockGetFavoriteMovies = MockGetFavoriteMovies();
    mockRemoveMovieFromFavorites = MockRemoveMovieFromFavorites();
    controller = FavoritesController(
      getFavoriteMovies: mockGetFavoriteMovies,
      removeMovieFromFavorites: mockRemoveMovieFromFavorites,
    );
  });

  final tFavoriteMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie 1',
      overview: 'Test Overview 1',
      voteAverage: 8.5,
      releaseDate: '2023-01-01',
      genreIds: [1, 2, 3],
      posterPath: '/test_poster1.jpg',
      backdropPath: '/test_backdrop1.jpg',
      isFavorite: true,
    ),
    const Movie(
      id: 2,
      title: 'Test Movie 2',
      overview: 'Test Overview 2',
      voteAverage: 7.5,
      releaseDate: '2023-02-01',
      genreIds: [4, 5, 6],
      posterPath: '/test_poster2.jpg',
      backdropPath: '/test_backdrop2.jpg',
      isFavorite: true,
    ),
  ];

  group('loadFavoriteMovies', () {
    test(
      'should update favoriteMovies when getFavoriteMovies returns success',
      () async {
        // arrange
        when(mockGetFavoriteMovies())
            .thenAnswer((_) async => Right(tFavoriteMovies));
        // act
        await controller.loadFavoriteMovies();
        // assert
        expect(controller.favoriteMovies, tFavoriteMovies);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, '');
        verify(mockGetFavoriteMovies());
      },
    );

    test(
      'should update errorMessage when getFavoriteMovies returns failure',
      () async {
        // arrange
        when(mockGetFavoriteMovies())
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.loadFavoriteMovies();
        // assert
        expect(controller.favoriteMovies, isEmpty);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, 'Server error');
        verify(mockGetFavoriteMovies());
      },
    );
  });

  group('removeFromFavorites', () {
    const tMovieId = 1;

    test(
      'should remove movie from favoriteMovies when removeMovieFromFavorites returns success',
      () async {
        // arrange
        controller.favoriteMovies.value = tFavoriteMovies;
        when(mockRemoveMovieFromFavorites(any))
            .thenAnswer((_) async => const Right(unit));
        // act
        await controller.removeFromFavorites(tMovieId);
        // assert
        expect(controller.favoriteMovies.length, 1);
        expect(controller.favoriteMovies[0].id, 2);
        expect(controller.errorMessage.value, '');
        verify(mockRemoveMovieFromFavorites(tMovieId));
      },
    );

    test(
      'should update errorMessage when removeMovieFromFavorites returns failure',
      () async {
        // arrange
        controller.favoriteMovies.value = tFavoriteMovies;
        when(mockRemoveMovieFromFavorites(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.removeFromFavorites(tMovieId);
        // assert
        expect(controller.favoriteMovies, tFavoriteMovies); // Unchanged
        expect(controller.errorMessage.value, 'Server error');
        verify(mockRemoveMovieFromFavorites(tMovieId));
      },
    );
  });

  group('updateMovie', () {
    test(
      'should add movie to favoriteMovies when movie is favorite and not in the list',
      () async {
        // arrange
        controller.favoriteMovies.value = [tFavoriteMovies[0]];
        const newFavoriteMovie = Movie(
          id: 3,
          title: 'Test Movie 3',
          overview: 'Test Overview 3',
          voteAverage: 9.0,
          releaseDate: '2023-03-01',
          genreIds: [7, 8, 9],
          posterPath: '/test_poster3.jpg',
          backdropPath: '/test_backdrop3.jpg',
          isFavorite: true,
        );
        // act
        controller.update([newFavoriteMovie]);
        // assert
        expect(controller.favoriteMovies.length, 2);
        expect(controller.favoriteMovies[1], newFavoriteMovie);
      },
    );

    test(
      'should not add movie to favoriteMovies when movie is favorite but already in the list',
      () async {
        // arrange
        controller.favoriteMovies.value = tFavoriteMovies;
        // act
        controller.update([tFavoriteMovies[0]]);
        // assert
        expect(controller.favoriteMovies, tFavoriteMovies); // Unchanged
      },
    );

    test(
      'should remove movie from favoriteMovies when movie is not favorite',
      () async {
        // arrange
        controller.favoriteMovies.value = tFavoriteMovies;
        const updatedMovie = Movie(
          id: 1,
          title: 'Test Movie 1',
          overview: 'Test Overview 1',
          voteAverage: 8.5,
          releaseDate: '2023-01-01',
          genreIds: [1, 2, 3],
          posterPath: '/test_poster1.jpg',
          backdropPath: '/test_backdrop1.jpg',
          isFavorite: false, // Changed to false
        );
        // act
        controller.update([updatedMovie]);
        // assert
        expect(controller.favoriteMovies.length, 1);
        expect(controller.favoriteMovies[0].id, 2);
      },
    );
  });
}

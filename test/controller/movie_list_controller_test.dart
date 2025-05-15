import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/get_movies.dart';
import 'package:movie_app/domain/usecases/search_movies.dart';
import 'package:movie_app/presentation/controllers/movie_list_controller.dart';

import 'movie_list_controller_test.mocks.dart';

@GenerateMocks([GetMovies, SearchMovies])
void main() {
  late MovieListController controller;
  late MockGetMovies mockGetMovies;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockGetMovies = MockGetMovies();
    mockSearchMovies = MockSearchMovies();
    controller = MovieListController(
      getMovies: mockGetMovies,
      searchMovies: mockSearchMovies,
    );
  });

  final tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      voteAverage: 8.5,
      releaseDate: '2023-01-01',
      genreIds: [1, 2, 3],
      posterPath: '/test_poster.jpg',
      backdropPath: '/test_backdrop.jpg',
    )
  ];

  group('fetchMovies', () {
    test(
      'should update movies when getMovies returns success',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovies));
        // act
        await controller.fetchMovies();
        // assert
        expect(controller.movies, tMovies);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, '');
        expect(controller.currentPage.value, 2);
        expect(controller.isLastPage.value, false);
        verify(mockGetMovies(1));
      },
    );

    test(
      'should update errorMessage when getMovies returns failure',
      () async {
        // arrange
        when(mockGetMovies(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.fetchMovies();
        // assert
        expect(controller.movies, isEmpty);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, 'Server error');
        verify(mockGetMovies(1));
      },
    );

    test(
      'should set isLastPage to true when getMovies returns empty list',
      () async {
        // arrange
        when(mockGetMovies(any)).thenAnswer((_) async => const Right([]));
        // act
        await controller.fetchMovies();
        // assert
        expect(controller.movies, isEmpty);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, '');
        expect(controller.isLastPage.value, true);
        verify(mockGetMovies(1));
      },
    );
  });

  group('search', () {
    const tQuery = 'test';

    test(
      'should update movies when searchMovies returns success',
      () async {
        // arrange
        when(mockSearchMovies(any)).thenAnswer((_) async => Right(tMovies));
        // act
        await controller.search(tQuery);
        // assert
        expect(controller.movies, tMovies);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, '');
        expect(controller.isSearching.value, true);
        expect(controller.searchQuery.value, tQuery);
        verify(mockSearchMovies(tQuery));
      },
    );

    test(
      'should update errorMessage when searchMovies returns failure',
      () async {
        // arrange
        when(mockSearchMovies(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        // act
        await controller.search(tQuery);
        // assert
        expect(controller.movies, isEmpty);
        expect(controller.isLoading.value, false);
        expect(controller.errorMessage.value, 'Server error');
        expect(controller.isSearching.value, true);
        expect(controller.searchQuery.value, tQuery);
        verify(mockSearchMovies(tQuery));
      },
    );

    test(
      'should reset search and load movies when query is empty',
      () async {
        // arrange
        controller.isSearching.value = true;
        controller.searchQuery.value = 'previous';
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovies));
        // act
        await controller.search('');
        // assert
        expect(controller.isSearching.value, false);
        expect(controller.searchQuery.value, '');
        verify(mockGetMovies(1));
      },
    );
  });

  group('refreshMovies', () {
    test(
      'should reset state and fetch movies',
      () async {
        // arrange
        controller.movies.value = tMovies;
        controller.currentPage.value = 3;
        controller.isLastPage.value = true;
        controller.isSearching.value = true;
        controller.searchQuery.value = 'test';
        when(mockGetMovies(any)).thenAnswer((_) async => Right(tMovies));
        // act
        await controller.refreshMovies();
        // assert
        expect(
            controller.currentPage.value, 2); // After fetch it increments to 2
        expect(controller.isLastPage.value, false);
        expect(controller.isSearching.value, false);
        expect(controller.searchQuery.value, '');
        verify(mockGetMovies(1));
      },
    );
  });
}

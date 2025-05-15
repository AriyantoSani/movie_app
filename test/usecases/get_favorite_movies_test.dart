import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/get_favorite_movies.dart';

import 'remove_movie_from_favorites_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetFavoriteMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetFavoriteMovies(mockMovieRepository);
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

  test(
    'should get favorite movies from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getFavoriteMovies())
          .thenAnswer((_) async => Right(tFavoriteMovies));
      // act
      final result = await usecase();
      // assert
      expect(result, Right(tFavoriteMovies));
      verify(mockMovieRepository.getFavoriteMovies());
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}

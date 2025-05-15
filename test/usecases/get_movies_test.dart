import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/get_movies.dart';

import 'remove_movie_from_favorites_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovies(mockMovieRepository);
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

  const tPage = 1;

  test(
    'should get movies from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMovies(any))
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase(tPage);
      // assert
      expect(result, Right(tMovies));
      verify(mockMovieRepository.getMovies(tPage));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}

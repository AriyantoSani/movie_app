import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/add_movie_to_favorites.dart';

import 'remove_movie_from_favorites_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late AddMovieToFavorites usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = AddMovieToFavorites(mockMovieRepository);
  });

  const tMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    voteAverage: 8.5,
    releaseDate: '2023-01-01',
    genreIds: [1, 2, 3],
    posterPath: '/test_poster.jpg',
    backdropPath: '/test_backdrop.jpg',
  );

  test(
    'should add movie to favorites in the repository',
    () async {
      // arrange
      when(mockMovieRepository.addMovieToFavorites(any))
          .thenAnswer((_) async => const Right(unit));
      // act
      final result = await usecase(tMovie);
      // assert
      expect(result, const Right(unit));
      verify(mockMovieRepository.addMovieToFavorites(tMovie));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}

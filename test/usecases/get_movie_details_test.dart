import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/get_movie_details.dart';

import 'remove_movie_from_favorites_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetMovieDetails usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetails(mockMovieRepository);
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

  test(
    'should get movie details from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMovieDetails(any))
          .thenAnswer((_) async => const Right(tMovie));
      // act
      final result = await usecase(tMovieId);
      // assert
      expect(result, const Right(tMovie));
      verify(mockMovieRepository.getMovieDetails(tMovieId));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}

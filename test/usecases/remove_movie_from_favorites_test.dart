import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';

import 'remove_movie_from_favorites_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late RemoveMovieFromFavorites usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveMovieFromFavorites(mockMovieRepository);
  });

  const tMovieId = 1;

  test(
    'should remove movie from favorites in the repository',
    () async {
      // arrange
      when(mockMovieRepository.removeMovieFromFavorites(any))
          .thenAnswer((_) async => const Right(unit));
      // act
      final result = await usecase(tMovieId);
      // assert
      expect(result, const Right(unit));
      verify(mockMovieRepository.removeMovieFromFavorites(tMovieId));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}

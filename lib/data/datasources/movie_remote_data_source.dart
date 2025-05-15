import 'package:movie_app/core/network/dio_client.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies(int page);
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieModel> getMovieDetails(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MovieModel>> getMovies(int page) async {
    final response = await dioClient.dio.get(
      ApiConstants.nowPlaying,
      queryParameters: {'page': page},
    );

    final results = response.data['results'] as List;

    return results.map((movie) => MovieModel.fromJson(movie)).toList();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dioClient.dio.get(
      ApiConstants.searchMovie,
      queryParameters: {'query': query},
    );

    final results = response.data['results'] as List;
    return results.map((movie) => MovieModel.fromJson(movie)).toList();
  }

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    final response = await dioClient.dio.get('${ApiConstants.movie}/$id');

    return MovieModel.fromJson(response.data);
  }
}

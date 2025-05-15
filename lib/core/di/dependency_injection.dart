import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/core/network/dio_client.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/domain/repositories/movie_repository.dart';
import 'package:movie_app/domain/usecases/add_movie_to_favorites.dart';
import 'package:movie_app/domain/usecases/get_favorite_movies.dart';
import 'package:movie_app/domain/usecases/get_movie_details.dart';
import 'package:movie_app/domain/usecases/get_movies.dart';
import 'package:movie_app/domain/usecases/remove_movie_from_favorites.dart';
import 'package:movie_app/domain/usecases/search_movies.dart';
import 'package:movie_app/presentation/controllers/favorites_controller.dart';
import 'package:movie_app/presentation/controllers/movie_detail_controller.dart';
import 'package:movie_app/presentation/controllers/movie_list_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    // External
    await Hive.initFlutter();
    final movieBox = await Hive.openBox<Map>(AppConstants.movie);

    // Core
    Get.lazyPut(() => DioClient(), fenix: true);

    // Data sources
    Get.lazyPut<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(movieBox: movieBox),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteDataSource: Get.find<MovieRemoteDataSource>(),
        localDataSource: Get.find<MovieLocalDataSource>(),
      ),
      fenix: true,
    );

    // Use cases
    Get.lazyPut(() => GetMovies(Get.find<MovieRepository>()), fenix: true);
    Get.lazyPut(() => SearchMovies(Get.find<MovieRepository>()), fenix: true);
    Get.lazyPut(() => GetMovieDetails(Get.find<MovieRepository>()),
        fenix: true);
    Get.lazyPut(() => GetFavoriteMovies(Get.find<MovieRepository>()),
        fenix: true);
    Get.lazyPut(() => AddMovieToFavorites(Get.find<MovieRepository>()),
        fenix: true);
    Get.lazyPut(() => RemoveMovieFromFavorites(Get.find<MovieRepository>()),
        fenix: true);

    // Controllers
    Get.lazyPut(
      () => MovieListController(
        getMovies: Get.find<GetMovies>(),
        searchMovies: Get.find<SearchMovies>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => MovieDetailController(
        getMovieDetails: Get.find<GetMovieDetails>(),
        addMovieToFavorites: Get.find<AddMovieToFavorites>(),
        removeMovieFromFavorites: Get.find<RemoveMovieFromFavorites>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => FavoritesController(
        getFavoriteMovies: Get.find<GetFavoriteMovies>(),
        removeMovieFromFavorites: Get.find<RemoveMovieFromFavorites>(),
      ),
      fenix: true,
    );
  }
}

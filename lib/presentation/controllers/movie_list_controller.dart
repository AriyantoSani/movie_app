import 'package:get/get.dart';
import 'package:movie_app/domain/entities/movie.dart';
import 'package:movie_app/domain/usecases/get_movies.dart';
import 'package:movie_app/domain/usecases/search_movies.dart';

class MovieListController extends GetxController {
  final GetMovies getMovies;
  final SearchMovies searchMovies;

  MovieListController({
    required this.getMovies,
    required this.searchMovies,
  });

  var movies = <Movie>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var isLastPage = false.obs;
  var searchQuery = ''.obs;
  var isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    if (isLoading.value || isLastPage.value) return;
    
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getMovies(currentPage.value);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (newMovies) {
        if (newMovies.isEmpty) {
          isLastPage.value = true;
        } else {
          movies.addAll(newMovies);
          currentPage.value++;
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> refreshMovies() async {
    movies.clear();
    currentPage.value = 1;
    isLastPage.value = false;
    await fetchMovies();
  }

  Future<void> search(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      isSearching.value = false;
      refreshMovies();
      return;
    }

    isSearching.value = true;
    isLoading.value = true;
    errorMessage.value = '';
    movies.clear();

    final result = await searchMovies(query);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (searchResults) {
        movies.value = searchResults;
      },
    );

    isLoading.value = false;
  }
}

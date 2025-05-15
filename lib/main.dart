import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/di/dependency_injection.dart';
import 'package:movie_app/core/utils/constants.dart';
import 'package:movie_app/presentation/pages/favorites_page.dart';
import 'package:movie_app/presentation/pages/movie_detail_page.dart';
import 'package:movie_app/presentation/pages/movie_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: RouterConstants.root,
      getPages: [
        GetPage(
          name: RouterConstants.root,
          page: () => const MovieListPage(),
        ),
        GetPage(
          name: '${RouterConstants.movieDetail}/:id',
          page: () => const MovieDetailPage(),
        ),
        GetPage(
          name: RouterConstants.favorites,
          page: () => const FavoritesPage(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

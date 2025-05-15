import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  @override
  final int id;

  @override
  final String title;

  @JsonKey(name: 'poster_path')
  @override
  final String? posterPath;

  @JsonKey(name: 'backdrop_path')
  @override
  final String? backdropPath;

  @override
  final String overview;

  @JsonKey(name: 'vote_average')
  @override
  final double? voteAverage;

  @JsonKey(name: 'release_date')
  @override
  final String? releaseDate;

  @JsonKey(name: 'genre_ids')
  @override
  final List<int>? genreIds;

  @override
  final bool isFavorite;

  const MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    this.isFavorite = false,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          backdropPath: backdropPath,
          overview: overview,
          voteAverage: voteAverage,
          releaseDate: releaseDate,
          genreIds: genreIds,
          isFavorite: isFavorite,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      genreIds: movie.genreIds,
      isFavorite: movie.isFavorite,
    );
  }
}

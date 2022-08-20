// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:movieapp/features/movie/data/datasources/get_movies_datasource.dart';
import 'package:movieapp/features/movie/data/dtos/movie_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_movies_datasource_decorator.dart';
import '../../../domain/entities/movie_entity.dart';

class GetMoviesLocalDataSourceDecoratorImp extends GetMoviesDataSourceDecorator {
  GetMoviesLocalDataSourceDecoratorImp(GetMoviesDataSource getMoviesDataSource) : super(getMoviesDataSource);

  @override
  Future<Either<Exception, MovieEntity>> call() async {
    return (await super()).fold(
      (error) async => Right(await _getInCache()),
      (result) {
        _saveInCache(result);
        return Right(result);
      },
    );
  }

  _saveInCache(MovieEntity movies) async {
    var prefs = await SharedPreferences.getInstance();
    String jsonMovies = jsonEncode(movies.toJson());
    prefs.setString('movies_cache', jsonMovies);
    print('salvou no cache ');
  }

  Future<MovieEntity> _getInCache() async {
    var prefs = await SharedPreferences.getInstance();
    var moviesJsonString = prefs.getString('movies_cache')!;
    var json = jsonDecode(moviesJsonString);
    var movies = MovieDto.fromJson(json);

    print('recuperou do cache os filmes $movies');
    return movies;
  }
}

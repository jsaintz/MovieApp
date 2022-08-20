import 'package:get_it/get_it.dart';
import 'package:movieapp/core/data/services/dio_htt_service_imp.dart';
import 'package:movieapp/core/domain/services/http_service.dart';
import 'package:movieapp/features/movie/data/datasources/get_movies_datasource.dart';
import 'package:movieapp/features/movie/data/datasources/local/get_movies_local_datasource_decorator_imp.dart';
import 'package:movieapp/features/movie/data/datasources/remote/get_movies_remote_datasource_imp.dart';

class Inject {
  static initialize() {
    GetIt getIt = GetIt.instance;

    // core
    getIt.registerLazySingleton<HttpService>(() => DioHttpServiceImp());

    // datasources
    getIt.registerLazySingleton<GetMoviesDataSource>(
      () => GetMoviesLocalDataSourceDecoratorImp(
        GetMoviesRemoteDatasourceImp(getIt()),
      ),
    );

    // repositories
    getIt.registerLazySingleton<GetMoviesRepository>(
      () => GetMoviesRepositoryImp(getIt()),
    );

    // usecases
    getIt.registerLazySingleton<GetMoviesUseCase>(
      () => GetMoviesUseCaseImp(getIt()),
    );

    // controllers
    getIt.registerLazySingleton<MovieController>(
      () => MovieController(getIt()),
    );
  }
}

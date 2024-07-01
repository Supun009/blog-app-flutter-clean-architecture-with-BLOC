import 'package:blogapp/core/common/cubit/cubit/app_cbit_cubit.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/features/auth/data/datasourses/auth_local_data_source.dart';
import 'package:blogapp/features/auth/data/datasourses/auth_remote_data_sourse.dart';
import 'package:blogapp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogapp/features/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/features/auth/domain/usecases/current_user.dart';
import 'package:blogapp/features/auth/domain/usecases/user_login.dart';
import 'package:blogapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogapp/features/blog/data/datasources/local_data_source.dart';
import 'package:blogapp/features/blog/data/repository/blog_rep%5Bository_impl.dart';
import 'package:blogapp/features/blog/domain/domain/repository/blog_repository.dart';
import 'package:blogapp/features/blog/domain/domain/usecase/get_all_blogs.dart';
import 'package:blogapp/features/blog/domain/domain/usecase/upload-blog.dart';
import 'package:blogapp/features/blog/presetation/bloc/blog_bloc_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependancies() async {
  final AuthLcalDataSource authLcalDataSourceImpl = AuthLcalDataSourceImpl();
  await authLcalDataSourceImpl.init();
  serviceLocator.registerSingleton<AuthLcalDataSource>(authLcalDataSourceImpl);
  serviceLocator.registerFactory<Connectionchecker>(
    () => ConnectionCheckerImpl(internetConnection: serviceLocator()),
  );
  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;
  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  _initauth();
  _initBlog();
}

void _initauth() {
  serviceLocator.registerFactory<AuthRemoteDataSourse>(
    () => AuthRemoteDataSourseImpl('http://10.0.2.2:3000'),
  );

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSourse: serviceLocator(),
      authLcalDataSource: serviceLocator(),
      connectionchecker: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserLogin(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AppCbitCubit(),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      authRepository: serviceLocator(),
      currentUser: serviceLocator(),
      appCbitCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(baseUrl: 'http://10.0.2.2:3000'),
  );

  serviceLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      blogRemoteDataSource: serviceLocator(),
      authLcalDataSource: serviceLocator(),
      connectionchecker: serviceLocator(),
      blogLocalDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadBlog(blogRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetAllBlogs(blogRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => BlogBlocBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    ),
  );
}

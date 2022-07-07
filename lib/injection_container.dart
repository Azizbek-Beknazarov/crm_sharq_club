import 'package:firebase_auth/firebase_auth.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'core/network/network_info.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repo.dart';
import 'features/auth/domain/usecase/get_current_user.dart';
import 'features/auth/domain/usecase/google_sign_in_or_sign_up.dart';
import 'features/auth/domain/usecase/login_user.dart';
import 'features/auth/domain/usecase/logout.dart';
import 'features/auth/domain/usecase/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/todo/data/datasources/todo_local_data_source.dart';
import 'features/todo/data/datasources/todo_remote_data_source.dart';
import 'features/todo/data/repository/todo_repository_impl.dart';
import 'features/todo/domain/repository/todo_repository.dart';
import 'features/todo/domain/usecase/add_todo.dart';
import 'features/todo/domain/usecase/delete_todo.dart';
import 'features/todo/domain/usecase/get_todos.dart';
import 'features/todo/domain/usecase/update_todo.dart';
import 'features/todo/presentation/bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';
import 'features/todo/presentation/bloc/get_todos/todo_bloc.dart';
import 'features/todo/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Bloc

  sl.registerFactory(() => AuthBloc(
    getCurrentUser: sl(),
    registerUser: sl(),
    loginUser: sl(),
    logout: sl(),
    googleSignInOrSignUp: sl(),
  ));

  sl.registerFactory(() => TodoBloc(
    getTodos: sl(),
  ));

  sl.registerFactory(() => AddDeleteUpdateTodoBloc(
    addTodo: sl(),
    updateTodo: sl(),
    deleteTodo: sl(),
  ));

  sl.registerFactory(() => InternetMonitorBloc(
    internetConnectionChecker: sl(),
  ));



  // Use cases

  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GoogleSignInOrSignUp(sl()));



  sl.registerLazySingleton(() => GetTodosUsecase(sl()));
  sl.registerLazySingleton(() => AddTodoUsecase(sl()));
  sl.registerLazySingleton(() => DeleteTodoUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTodoUsecase(sl()));


  // Repository

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );



  // Data sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(auth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<TodoLocalDataSource>(
        () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );


  final sharedPreferences = await SharedPreferences.getInstance();

  AuthLocalDataSourceImpl authLocalDataSource =
  AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  sl.registerLazySingleton<TodoRemoteDataSource>(
        () => TodoRemoteDataSourceImpl(authLocalDataSource: authLocalDataSource),
  );

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => _googleSignIn);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

import 'package:crm_sharq_club/features/customer/cars/data/datasource/car_local_ds.dart';
import 'package:crm_sharq_club/features/customer/cars/data/datasource/car_remote_ds.dart';
import 'package:crm_sharq_club/features/customer/cars/data/repository/car_repository_impl.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/repository/car_repository.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/add_new_car_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/delete_car_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/get_cars_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/update_car_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/add_delete_update_car/add_delete_update_car_bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/get_cars/getcars_bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';
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

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Bloc

  sl.registerFactory(() =>
      AuthBloc(
        getCurrentUser: sl(),
        registerUser: sl(),
        loginUser: sl(),
        logout: sl(),
        googleSignInOrSignUp: sl(),
      ));

  sl.registerFactory(() =>
      AddDeleteUpdateCarBloc(
          addNewCarUseCase: sl(),
          updateCarUseCase: sl(),
          deleteCarUseCase: sl()));

  sl.registerFactory(() => GetCarBloc(getCarsUseCase: sl()));

  sl.registerFactory(() => InternetMonitorBloc(internetConnectionChecker: sl()));

  // Use cases

  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GoogleSignInOrSignUp(sl()));

  sl.registerLazySingleton(() => AddNewCarUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCarUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCarUseCase(sl()));
  sl.registerLazySingleton(() => GetCarsUseCase(sl()));

  // Repository

  sl.registerLazySingleton<AuthRepository>(
        () =>
        AuthRepositoryImpl(
          localDataSource: sl(),
          networkInfo: sl(),
          remoteDataSource: sl(),
        ),
  );

  sl.registerLazySingleton<CarRepository>(() =>
      CarRepositoryImpl(
          carLocalDataSource: sl(),
          carRemoteDataSource: sl(),
          networkInfo: sl()));


  // Data sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(auth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<CarLocalDataSource>(() =>
      CarLocalDataSourceImpl(sharedPreferences: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();

  AuthLocalDataSourceImpl authLocalDataSource =
  AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  sl.registerLazySingleton<CarRemoteDataSource>(() =>
      CarRemoteDataSourceImpl(authLocalDataSourceImpl: authLocalDataSource));

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

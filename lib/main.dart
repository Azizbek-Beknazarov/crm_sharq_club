import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/get_cars/getcars_bloc.dart';
import 'package:crm_sharq_club/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_themes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/customer/cars/presentation/bloc/add_delete_update_car/add_delete_update_car_bloc.dart';
import 'features/customer/cars/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => sl<AuthBloc>()..add(GetCurrentUserEvent())),
          BlocProvider(create: (_) => sl<GetCarBloc>()),
          BlocProvider(create: (_) => sl<AddDeleteUpdateCarBloc>()),
          BlocProvider<InternetMonitorBloc>(
            create: (_) =>
            sl<InternetMonitorBloc>()..add(InternetMonitorEvent())),

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todos',
          theme: appTheme,
          home: SplashScreen(),
        ));
  }
}

import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/add_delete_update_car/add_delete_update_car_bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/get_cars/getcars_bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/widgets/add_floating_button.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/widgets/car_item.dart';
import 'package:crm_sharq_club/features/customer/cars/presentation/widgets/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/widgets/logout_button.dart';



class CarListPage extends StatelessWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: AddFloatingButton());
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/app-icon.png'),
        ),
      ),
      title: Text(
        "Cars",
      ),
      actions: [LogoutButton()],
    );
  }

  Widget _buildBody() {
    return BlocListener<AddDeleteUpdateCarBloc, AddDeleteUpdateCarState>(
      listener: (context, state) async {
        await Future.delayed(Duration(milliseconds: 200), () {
          if (state is CarErrorState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is CarMessageState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
          }
        });
      },
      child: _buildConnectionMoniter(),
    );
  }

  Widget _buildConnectionMoniter() {
    return Builder(builder: (context) {
      final connectionState = context.watch<InternetMonitorBloc>().state;

      if (connectionState is InternetConnectionDisconnected) {
        return NoInternet();
      } else if (connectionState is InternetConnectionLoading) {
        return LoadingWidget();
      } else {
        return _buildCars();
      }
    });
  }

  BlocBuilder<GetCarBloc, GetCarState> _buildCars() {
    return BlocBuilder<GetCarBloc, GetCarState>(
      builder: (context, state) {
        if (state is LoadedGetCarsState) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: state.cars
                  .map((car) => CarItem(
                car: car,
              ))
                  .toList(),
            ),
          );
        } else if (state is CarErrorState) {
          return NoInternet();
        } else if (state is CarLoadingState || state is CarInitialState) {
          return LoadingWidget();
        }

        return Container();
      },
    );
  }
}

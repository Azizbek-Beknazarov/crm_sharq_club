// ignore_for_file: cancel_subscriptions, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../domain/usecase/get_cars_usecase.dart';
import '../../../domain/entity/car.dart';



part 'getcars_event.dart';
part 'getcars_state.dart';

class GetCarBloc extends Bloc<GetCarEvent, GetCarState> {
  final GetCarsUseCase getCarsUseCase;
  StreamSubscription? carsStreamSubscription;
  GetCarBloc({
    required this.getCarsUseCase,
  }) : super(GetCarInitialState()) {

    //
    on<GetCarEvent>((event, emit) async {
      //
      if (event is GetAllCarEvent) {
        emit(GetCarLoadingState());
        final failureOrDone = await getCarsUseCase();
        failureOrDone.fold(
                (failure) =>
                emit(GetCarErrorState(message: _mapFailureToMessage(failure))),
                (cars) {
              try {
                carsStreamSubscription!.cancel();
              } catch (e) {}
              carsStreamSubscription = cars.listen((carList) {
                emitLoadedCars(carList);
              });
            });
      }
    });
  }
  void emitLoadedCars(cars) => emit(LoadedGetCarsState(cars: cars));

  @override
  Future<void> close() async {
    carsStreamSubscription!.cancel();
    return super.close();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case InvalidDataFailure:
        return INVALID_DATA_FAILURE_MESSAGE;
      case FirebaseDataFailure:
        final FirebaseDataFailure _firebaseFailure =
        failure as FirebaseDataFailure;
        return _firebaseFailure.message;
      default:
        return 'Unexpected Error, Please try again later .';
    }
  }
}

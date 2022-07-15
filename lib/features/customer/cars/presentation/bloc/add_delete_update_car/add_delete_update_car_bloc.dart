import 'package:bloc/bloc.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/add_new_car_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/delete_car_usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/usecase/update_car_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/strings/failures.dart';
import '../../../../../../core/strings/messages.dart';
import '../../../../../../features/customer/cars/domain/entity/car.dart';


part 'add_delete_update_car_event.dart';
part 'add_delete_update_car_state.dart';

class AddDeleteUpdateCarBloc
    extends Bloc<AddDeleteUpdateCarEvent, AddDeleteUpdateCarState> {
  final AddNewCarUseCase addNewCarUseCase;
  final UpdateCarUseCase updateCarUseCase;
  final DeleteCarUseCase deleteCarUseCase;
  AddDeleteUpdateCarBloc(
      {required this.addNewCarUseCase,
        required this.updateCarUseCase,
        required this.deleteCarUseCase})
      : super(CarInitialState()) {
    on<AddDeleteUpdateCarEvent>((event, emit) async {
      if (event is AddCarEvent) {
        emit(CarLoadingState());
        final failureOrDone = await addNewCarUseCase(event.car);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: ADD_SUSCESS_MESSAGE));
      } else if (event is UpdateCarEvent) {
        emit(CarLoadingState());
        final failureOrDone = await updateCarUseCase(event.car);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: UPDATE_SUSCESS_MESSAGE));
      } else if (event is DeleteCarEvent) {
        emit(CarLoadingState());
        final failureOrDone = await deleteCarUseCase(event.car);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: DELETE_SUSCESS_MESSAGE));
      }
    });
  }

  AddDeleteUpdateCarState _eitherFailureOrDone(
      {required Either<Failure, void> either, required String successMessage}) {
    return either.fold(
          (failure) =>CarErrorState(message:  _mapFailureToMessage(failure), ),
          (_) => CarMessageState(message: successMessage),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case NotFoundFailure:
        return NOT_FOUND_FAILURE_MESSAGE;
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

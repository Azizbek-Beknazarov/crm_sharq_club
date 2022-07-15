part of 'add_delete_update_car_bloc.dart';



abstract class AddDeleteUpdateCarState extends Equatable {
  const AddDeleteUpdateCarState();

  @override
  List<Object> get props => [];
}

class CarInitialState extends AddDeleteUpdateCarState {}

class CarLoadingState extends AddDeleteUpdateCarState {}

class CarErrorState extends AddDeleteUpdateCarState {
  final String message;

  const CarErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class CarMessageState extends AddDeleteUpdateCarState {
  final String message;

  const CarMessageState({required this.message});

  @override
  List<Object> get props => [message];
}

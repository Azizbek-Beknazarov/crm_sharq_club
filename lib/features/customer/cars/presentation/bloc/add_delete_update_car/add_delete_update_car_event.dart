part of 'add_delete_update_car_bloc.dart';

abstract class AddDeleteUpdateCarEvent extends Equatable {
  const AddDeleteUpdateCarEvent();

  @override
  List<Object> get props => [];
}

class AddCarEvent extends AddDeleteUpdateCarEvent {
  final Car car;

  AddCarEvent(this.car);

  @override
  List<Object> get props => [car];
}

class UpdateCarEvent extends AddDeleteUpdateCarEvent {
  final Car car;

  UpdateCarEvent(this.car);

  @override
  List<Object> get props => [car];
}

class DeleteCarEvent extends AddDeleteUpdateCarEvent {
  final Car car;

  DeleteCarEvent(this.car);

  @override
  List<Object> get props => [car];
}

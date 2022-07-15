part of 'getcars_bloc.dart';



abstract class GetCarState extends Equatable {
  const GetCarState();

  @override
  List<Object> get props => [];
}

//1
class GetCarInitialState extends GetCarState {}

//2
class GetCarLoadingState extends GetCarState {}

//3
class GetCarErrorState extends GetCarState {
  final String message;

  const GetCarErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//4
class GetCarMessageState extends GetCarState {
  final String message;

  const GetCarMessageState({required this.message});

  @override
  List<Object> get props => [message];
}

//5
class LoadedGetCarsState extends GetCarState {
  final List<Car> cars;

  LoadedGetCarsState({
    required this.cars,
  });

  @override
  List<Object> get props => [cars];
}

import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String carName;
  final String? id;

  Car({required this.carName, this.id});

  @override
  List<Object?> get props => [carName, id];
}

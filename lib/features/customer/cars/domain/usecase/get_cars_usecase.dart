import 'package:crm_sharq_club/core/error/failures.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/repository/car_repository.dart';
import 'package:dartz/dartz.dart';

import '../entity/car.dart';
class GetCarsUseCase{
  final CarRepository carRepository;
  GetCarsUseCase(this.carRepository);

  Future<Either<Failure,Stream<List<Car>>>> call(){
    return carRepository.carList();
  }
}
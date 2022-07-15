import 'package:crm_sharq_club/core/error/failures.dart';
import 'package:crm_sharq_club/core/usecases/usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/entity/car.dart';
import 'package:dartz/dartz.dart';

import '../repository/car_repository.dart';

class DeleteCarUseCase extends UseCase<void, Car>{
  final CarRepository carRepository;
  DeleteCarUseCase(this.carRepository);

  @override
  Future<Either<Failure, void>> call(Car car) async{
   return await carRepository.deleteCar(car);
  }
}
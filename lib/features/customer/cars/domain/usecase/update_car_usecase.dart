import 'package:crm_sharq_club/core/error/failures.dart';
import 'package:crm_sharq_club/core/usecases/usecase.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/entity/car.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/repository/car_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCarUseCase extends UseCase<void, Car>{
  final CarRepository carRepository;
  UpdateCarUseCase(this.carRepository);

  @override
  Future<Either<Failure, void>> call(Car car)async {
    return await carRepository.updateCar(car);
  }


}
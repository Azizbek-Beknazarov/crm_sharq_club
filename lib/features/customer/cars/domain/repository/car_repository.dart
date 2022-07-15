import 'package:crm_sharq_club/core/error/failures.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/entity/car.dart';
import 'package:dartz/dartz.dart';

abstract class CarRepository{
 Future<Either<Failure, void>> addNewCar(Car car);
 Future<Either<Failure, void>> updateCar(Car car);
 Future<Either<Failure, void>> deleteCar(Car car);
 Future<Either<Failure, Stream<List<Car>>>> carList();
}
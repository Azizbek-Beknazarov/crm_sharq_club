import 'package:crm_sharq_club/core/error/exception.dart';
import 'package:crm_sharq_club/core/error/failures.dart';
import 'package:crm_sharq_club/core/network/network_info.dart';
import 'package:crm_sharq_club/features/customer/cars/data/datasource/car_local_ds.dart';
import 'package:crm_sharq_club/features/customer/cars/data/datasource/car_remote_ds.dart';
import 'package:crm_sharq_club/features/customer/cars/data/model/car_model.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/entity/car.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/repository/car_repository.dart';
import 'package:dartz/dartz.dart';

class CarRepositoryImpl implements CarRepository {
  final CarLocalDataSource carLocalDataSource;
  final CarRemoteDataSource carRemoteDataSource;
  final NetworkInfo networkInfo;

  CarRepositoryImpl(
      {required this.carLocalDataSource,
      required this.carRemoteDataSource,
      required this.networkInfo});

  //1
  @override
  Future<Either<Failure, void>> addNewCar(Car car) async {
    if (await networkInfo.isConnected) {
      try {
        carRemoteDataSource.addCar(CarModel(carName: car.carName));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  //2
  @override
  Future<Either<Failure, Stream<List<Car>>>> carList() async {
    if (await networkInfo.isConnected) {
      try {
        Stream<List<Car>> cars=carRemoteDataSource.cars();
        return Right(cars);
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }catch(e){return Left(NotFoundFailure());}

    } else {
      return Left(OfflineFailure());
    }
  }

  //3
  @override
  Future<Either<Failure, void>> deleteCar(Car car) async {
    if (await networkInfo.isConnected) {
      try {
        carRemoteDataSource.deleteCar(CarModel(carName: car.carName));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }catch(e){return Left(NotFoundFailure());}

    } else {
      return Left(OfflineFailure());
    }
  }

  //4
  @override
  Future<Either<Failure, void>> updateCar(Car car) async {
    if (await networkInfo.isConnected) {
      try {
        carRemoteDataSource.updateCar(CarModel(carName: car.carName));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }catch(e){return Left(NotFoundFailure());}

    } else {
      return Left(OfflineFailure());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_sharq_club/core/error/exception.dart';
import 'package:crm_sharq_club/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:crm_sharq_club/features/auth/data/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/car_model.dart';

final String KEY_CARS = 'cars';

abstract class CarRemoteDataSource {
  Future<void> addCar(CarModel carModel);

  Future<void> updateCar(CarModel carModel);

  Future<void> deleteCar(CarModel carModel);

  Stream<List<CarModel>> cars();
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  AuthLocalDataSourceImpl authLocalDataSourceImpl;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  Reference reference = FirebaseStorage.instance.ref();

  //
  CarRemoteDataSourceImpl({required this.authLocalDataSourceImpl});

  //get current user
  Future<UserModel> get currentUser async =>
      await authLocalDataSourceImpl.getCurrentUser();

  Future<DocumentReference> getCurrentUserDoc() async {
    UserModel currentUserModel = await currentUser;
    return collectionReference.doc(currentUserModel.id);
  }

  //_updateOrDeleteCar
  Future<void> _updateOrDeleteCar(
      {required bool isUpdate, required CarModel carModel}) async {
    await getCurrentUserDoc().then((value) async {
      final carDoc = value.collection(KEY_CARS).doc(carModel.id);
      final bool isCarExists = await carDoc.get().then((value) => value.exists);

      if (isCarExists) {
        isUpdate
            ? await value
                .collection(KEY_CARS)
                .doc(carModel.id)
                .update(carModel.toJson()
                  ..addAll({
                    'serverTimeStamp': FieldValue.serverTimestamp(),
                  }))
            : await value.collection(KEY_CARS).doc(carModel.id).delete();
      } else {
        throw (NotFoundException);
      }
    });
  }

  //1
  @override
  Future<void> addCar(CarModel carModel) async {
    await getCurrentUserDoc().then((value) async {
      await value.collection(KEY_CARS).add(carModel.toJson()
        ..addAll({
          'serverTimeStamp': FieldValue.serverTimestamp(),
        }));
    });
  }

  //2
  @override
  Stream<List<CarModel>> cars() async* {
    final currentUserDoc = await getCurrentUserDoc();

    yield* currentUserDoc
        .collection(KEY_CARS)
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => CarModel.fromEntity(CarModel.fromSnapshot(e)))
          .toList();
    });
  }

  //3
  @override
  Future<void> deleteCar(CarModel carModel) async {
    await _updateOrDeleteCar(isUpdate: false, carModel: carModel);
  }

  //4
  @override
  Future<void> updateCar(CarModel carModel) async {
    await _updateOrDeleteCar(isUpdate: true, carModel: carModel);
  }
}

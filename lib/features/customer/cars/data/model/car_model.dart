import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_sharq_club/features/customer/cars/domain/entity/car.dart';

class CarModel extends Car {
  CarModel({String? id, required String carName})
      : super(id: id, carName: carName);

  //1
  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'carName': carName,
    });
  }

  //2
  factory CarModel.fromSnapshot(QueryDocumentSnapshot documentSnapshot) {
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    return CarModel(carName: data!['carName'] ?? "", id: documentSnapshot.id);
  }

  //3
factory CarModel.fromEntity(Car entity){
    return CarModel(carName: entity.carName,id: entity.id);
}
  //4
factory CarModel.fromJson(Map<String, Object> json){
    return CarModel(carName: json['carName'] as String, id: json['id']as String);
}

}

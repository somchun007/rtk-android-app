// ignore_for_file: file_names, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressDetail {
  String? id;
  String? item;
  double? accuracy;
  double? altitude;
  double? latitude;
  double? longitude;
  String? province;
  String? district;
  String? subdistrict;
  String? postcode;
  String? added_by;
  int? timestamp;
  String? approve;
  String? watertype;
  String? description;
  String? urlImage1;
  String? urlImage2;
  String? urlImage3;
  String? urlImage4;
  String? urlImage5;
  String? urlAudio;

  AddressDetail({
    this.id,
    this.item,
    this.accuracy,
    this.added_by,
    this.altitude,
    this.approve,
    this.district,
    this.latitude,
    this.longitude,
    this.postcode,
    this.province,
    this.subdistrict,
    this.timestamp,
    this.urlImage1,
    this.urlImage2,
    this.urlImage3,
    this.urlImage4,
    this.urlImage5,
    this.watertype,
    this.description,
    this.urlAudio,
  });

  // toJson() {
  //   return 'id: $id , accuracy: $accuracy , altitude: $altitude , latitude: $latitude , longitude: $longitude , provice: $provice , district: $district , subdistrict: $subdistrict , postcode: $postcode , added_by: $added_by , timestamp: $timestamp , approve: $approve , watertype: $watertype , urlImage1: $urlImage1 , urlImage2: $urlImage2 , urlImage3: $urlImage3 , urlImage4: $urlImage4 , urlImage5: $urlImage5';
  // }
  @override
  String toString() {
    // "id: $id";
    // "firstname: $firstname";
    // "lastname: $lastname";
    // "email: $email";
    // "password: $password";
    return 'id: $id , item: $item , accuracy: $accuracy , altitude: $altitude , latitude: $latitude , longitude: $longitude , provice: $province , district: $district , subdistrict: $subdistrict , postcode: $postcode , added_by: $added_by , timestamp: $timestamp , approve: $approve , watertype: $watertype , description: $description , urlImage1: $urlImage1 , urlImage2: $urlImage2 , urlImage3: $urlImage3 , urlImage4: $urlImage4 , urlImage5: $urlImage5 , urlAudio: $urlAudio';
  }

  // factory AddressDetail.formSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data();
  //   // Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return AddressDetail(
  //     id: document.id,
  //     accuracy: data?['accuracy'],
  //     altitude: data?['altitude'],
  //     latitude: data?['latitude'],
  //     longitude: data?['longitude'],
  //     provice: data?['provice'],
  //     district: data?['district'],
  //     subdistrict: data?['subdistrict'],
  //     postcode: data?['postcode'],
  //     added_by: data?['added_by'],
  //     timestamp: data?['timestamp'],
  //     approve: data?['approve'],
  //     watertype: data?['watertype'],
  //     urlImage1: data?['urlImage1'],
  //     urlImage2: data?['urlImage2'],
  //     urlImage3: data?['urlImage3'],
  //     urlImage4: data?['urlImage4'],
  //     urlImage5: data?['urlImage5'],
  //   );
  // }

  factory AddressDetail.formMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AddressDetail(
      id: snapshot.id,
      item: data['item'],
      accuracy: data['accuracy'],
      altitude: data['altitude'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      province: data['province'],
      district: data['district'],
      subdistrict: data['subdistrict'],
      postcode: data['postcode'],
      added_by: data['added_by'],
      timestamp: data['timestamp'],
      approve: data['approve'],
      watertype: data['watertype'],
      description: data['description'],
      urlImage1: data['urlImage1'],
      urlImage2: data['urlImage2'],
      urlImage3: data['urlImage3'],
      urlImage4: data['urlImage4'],
      urlImage5: data['urlImage5'],
      urlAudio: data['urlAudio'],
    );
  }
}

// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? id;
  String? email;
  String? password;
  String? fullname;
  String? tel;
  String? imageRrofile;

  Profile({
    this.id,
    this.email,
    this.password,
    this.fullname,
    this.tel,
    this.imageRrofile,
  });

  @override
  String toString() {
    // "id: $id";
    // "firstname: $firstname";
    // "lastname: $lastname";
    // "email: $email";
    // "password: $password";
    return 'id: $id , email: $email , password: $password , fullname : $fullname , tel: $tel , imageRrofile: $imageRrofile';
  }

  factory Profile.formMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Profile(
      id: snapshot.id,
      email: data['email'],
      password: data['password'],
      fullname: data['fullname'],
      tel: data['tel'],
      imageRrofile: data['imageRrofile'],

      // id: document['id'],
      // email: document['email'],
      // password: document['password'],
      // firstname: document['firstname'],
      // lastname: document['lastname'],
    );
  }
}

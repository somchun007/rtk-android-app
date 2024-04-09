// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTest {
  String? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  ProfileTest({
    this.id,
    this.email,
    this.password,
    this.firstname,
    this.lastname,
  });

  @override
  String toString() {
    // "id: $id";
    // "firstname: $firstname";
    // "lastname: $lastname";
    // "email: $email";
    // "password: $password";
    return 'id: $id , email: $email , password: $password , firstname : $firstname , lastname: $lastname';
  }

  factory ProfileTest.formMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ProfileTest(
      id: snapshot.id,
      email: data['email'],
      password: data['password'],
      firstname: data['firstname'],
      lastname: data['lastname'],

      // id: document['id'],
      // email: document['email'],
      // password: document['password'],
      // firstname: document['firstname'],
      // lastname: document['lastname'],
    );
  }
}

import 'package:eventure/services/db/models/entity.dart';
import 'dart:typed_data';

class User implements Entity {
  final String? id;
  final Uint8List profilePicture;
  final String studyCourse;
  final String firstName;
  final String lastName;
  final String description;
  final String uni;
  final List<String> socialMediaLinks;
  final List<String>? friends;

  User({
    this.id,
    required this.profilePicture,
    required this.studyCourse,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.uni,
    required this.socialMediaLinks,
    this.friends
});

  factory User.fromMap(Map<String, dynamic> map, String id){
    return User(
      id: id,
      profilePicture: map['profilePicture'] as Uint8List,
      studyCourse: map['studyCourse'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      description:  map['description'] as String,
      uni: map['uni'] as String,
      socialMediaLinks: map['socialMediaLinks'] as List<String>,
      friends: map['friends'] as List<String>
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profilePicture': profilePicture,
      'studyCourse': studyCourse,
      'firstName': firstName,
      'lastName': lastName,
      'description': description,
      'uni': uni,
      'socialMediaLinks': socialMediaLinks,
      'friends': friends
    };
  }

  @override
  String toString() {
    return 'id : $id \n profilePicture: $profilePicture \n studyCourse: $studyCourse \n'
        'firstName: $firstName \n lastName: $lastName \n description: $description \n'
        'uni: $uni \n socialMediaLink: $socialMediaLinks \n friends: $friends';
  }

}
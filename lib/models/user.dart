import 'package:eventure/services/db/models/entity.dart';
import 'dart:typed_data';

class AppUser implements Entity {
  final String? id;
  final String username;
  final Map<String,dynamic>? profilePicture;
  final String? studyCourse;
  final String? firstName;
  final String? lastName;
  final String? description;
  final String? uni;
  final List<String?>? socialMediaLinks;
  final List<String?>? friends;

  AppUser(
      {this.id,
      required this.username,
      this.profilePicture,
      this.studyCourse,
      this.firstName,
      this.lastName,
      this.description,
      this.uni,
      this.socialMediaLinks,
      this.friends});

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      username: map['username'] as String,
      profilePicture: map['profilePicture'] as Map<String,dynamic>?,
      studyCourse: map['studyCourse'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      description: map['description'] as String?,
      uni: map['uni'] as String?,
      socialMediaLinks: (map['socialMediaLinks'] as List<dynamic>?)
          ?.map((item) => item as String?)
          .toList(),
      friends: (map['friends'] as List<dynamic>?)
          ?.map((item) => item as String?)
          .toList(),
    );
  }

  AppUser copyWith({
    String? id,
    String? username,
    Map<String,dynamic>? profilePicture,
    String? studyCourse,
    String? firstName,
    String? lastName,
    String? description,
    String? uni,
    List<String>? socialMediaLinks,
    List<String>? friends,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      studyCourse: studyCourse ?? this.studyCourse,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      uni: uni ?? this.uni,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      friends: friends ?? this.friends,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
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
    return 'id : $id \n username: $username \n profilePicture: $profilePicture \n '
        'studyCourse: $studyCourse \n'
        'firstName: $firstName \n lastName: $lastName \n description: $description \n'
        'uni: $uni \n socialMediaLink: $socialMediaLinks \n friends: $friends';
  }
}

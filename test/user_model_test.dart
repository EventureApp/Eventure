//test/user_model_test.dart
import 'package:eventure/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';

void main() {
  group('AppUser Model Tests', () {
    test('AppUser should be correctly created from a map', () {
      final Map<String, dynamic> map = {
        'username': 'testUser',
        'profilePicture': Uint8List.fromList([0, 1, 2, 3]),
        'studyCourse': 'Computer Science',
        'firstName': 'John',
        'lastName': 'Doe',
        'description': 'A sample description',
        'uni': 'Sample University',
        'socialMediaLinks': ['https://facebook.com/johndoe', 'https://twitter.com/johndoe'],
        'friends': ['friend1', 'friend2']
      };

      final user = AppUser.fromMap(map, 'userId123');

      expect(user.id, 'userId123');
      expect(user.username, 'testUser');
      expect(user.profilePicture, isNotNull);
      expect(user.studyCourse, 'Computer Science');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.description, 'A sample description');
      expect(user.uni, 'Sample University');
      expect(user.socialMediaLinks, ['https://facebook.com/johndoe', 'https://twitter.com/johndoe']);
      expect(user.friends, ['friend1', 'friend2']);
    });

    test('copyWith should return a new AppUser with updated fields', () {
      final originalUser = AppUser(
          id: 'userId123',
          username: 'testUser',
          profilePicture: Uint8List.fromList([0, 1, 2, 3]),
          studyCourse: 'Computer Science',
          firstName: 'John',
          lastName: 'Doe',
          description: 'A sample description',
          uni: 'Sample University',
          socialMediaLinks: ['https://facebook.com/johndoe'],
          friends: ['friend1']
      );

      final updatedUser = originalUser.copyWith(username: 'newUser', friends: ['friend1', 'friend2']);

      expect(updatedUser.username, 'newUser');
      expect(updatedUser.friends, ['friend1', 'friend2']);
      expect(updatedUser.id, originalUser.id);
    });

    test('toMap should return a valid map representation of AppUser', () {
      final user = AppUser(
          id: 'userId123',
          username: 'testUser',
          profilePicture: Uint8List.fromList([0, 1, 2, 3]),
          studyCourse: 'Computer Science',
          firstName: 'John',
          lastName: 'Doe',
          description: 'A sample description',
          uni: 'Sample University',
          socialMediaLinks: ['https://facebook.com/johndoe'],
          friends: ['friend1']
      );

      final userMap = user.toMap();

      expect(userMap['id'], 'userId123');
      expect(userMap['username'], 'testUser');
      expect(userMap['profilePicture'], isNotNull);
      expect(userMap['studyCourse'], 'Computer Science');
      expect(userMap['firstName'], 'John');
      expect(userMap['lastName'], 'Doe');
      expect(userMap['description'], 'A sample description');
      expect(userMap['uni'], 'Sample University');
      expect(userMap['socialMediaLinks'], ['https://facebook.com/johndoe']);
      expect(userMap['friends'], ['friend1']);
    });

    test('toString should return a readable string representation of AppUser', () {
      final user = AppUser(
          id: 'userId123',
          username: 'testUser',
          profilePicture: Uint8List.fromList([0, 1, 2, 3]),
          studyCourse: 'Computer Science',
          firstName: 'John',
          lastName: 'Doe',
          description: 'A sample description',
          uni: 'Sample University',
          socialMediaLinks: ['https://facebook.com/johndoe'],
          friends: ['friend1']
      );

      final userString = user.toString();

      expect(userString, contains('id : userId123'));
      expect(userString, contains('username: testUser'));
      expect(userString, contains('studyCourse: Computer Science'));
      expect(userString, contains('firstName: John'));
      expect(userString, contains('lastName: Doe'));
      expect(userString, contains('description: A sample description'));
      expect(userString, contains('socialMediaLink: [https://facebook.com/johndoe]'));
      expect(userString, contains('friends: [friend1]'));
    });
  });
}

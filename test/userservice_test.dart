import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/models/user.dart';
import 'package:eventure/services/db/user_service.dart';

import 'mocks.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late UserService userService;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    userService = UserService();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocument = MockDocumentReference<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDocumentSnapshot =
        MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocument);
  });

  test('create user', () async {
    final user = AppUser(id: '1', username: 'testuser');
    when(mockDocument.set(any)).thenAnswer((_) async => {});

    await userService.create(user);

    verify(mockDocument.set(user.toMap())).called(1);
  });

  test('get single user', () async {
    final user = AppUser(id: '1', username: 'testuser');
    when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn(user.toMap());

    final result = await userService.getSingleUser('1');

    expect(result.username, user.username);
  });

  test('get all users', () async {
    final user = AppUser(id: '1', username: 'testuser');
    when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.data()).thenReturn(user.toMap());

    final result = await userService.getAll();

    expect(result.length, 1);
    expect(result.first.username, user.username);
  });

  test('update user', () async {
    final user = AppUser(id: '1', username: 'updateduser');
    when(mockDocument.update(any)).thenAnswer((_) async => {});

    await userService.update(user);

    verify(mockDocument.update(user.toMap())).called(1);
  });

  test('delete user', () async {
    when(mockDocument.delete()).thenAnswer((_) async => {});

    await userService.delete('1');

    verify(mockDocument.delete()).called(1);
  });
}

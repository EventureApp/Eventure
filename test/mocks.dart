import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>
])
void main() {}

// test/mocks/mock_services.dart
import 'package:mockito/annotations.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/providers/event_provider.dart';

@GenerateMocks([UserProvider, EventProvider])
void main() {}

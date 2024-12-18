import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/auth/elegant_signin_screen.dart';
import 'package:eventure/screens/auth/elegant_signup_screen.dart';
import 'package:eventure/screens/chat/chat_view.dart';
import 'package:eventure/screens/events/detail_view.dart';
import 'package:eventure/screens/events/event-screen.dart';
import 'package:eventure/screens/filter/filter-screen.dart';
import 'package:eventure/screens/home/home_page.dart';
import 'package:eventure/screens/profile/add_friends.dart';
import 'package:eventure/screens/profile/user_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) {
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  }).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (context) => LocationProvider()),
          ChangeNotifierProvider(create: (context) => EventProvider()),
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: const App(),
      ),
    );
  });
}

final _router = GoRouter(
  redirect: (context, state) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initializeUser();
    final isOnAuthPage = state.uri.toString() == '/sign-in' ||
        state.uri.toString() == '/sign-up';

    if (!authProvider.isLoggedIn && !isOnAuthPage) {
      return '/sign-in';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) =>
              PopScope(canPop: false, child: const ElegantSignInScreen()),
        ),
        GoRoute(
          path: '/sign-up', // <- Hier ist der Fehler: führender Slash
          builder: (context, state) => const ElegantSignUpScreen(),
        ),
        GoRoute(
            path: 'profile',
            builder: (context, state) {
              return Consumer<AuthenticationProvider>(
                  builder: (context, authProvider, _) =>
                      const ProfileDetailScreen());
            }),
        GoRoute(
            path: "userList",
            builder: (context, state) {
              return AddFriendsScreen();
            }),
        GoRoute(
            path: "addEvent",
            builder: (context, state) {
              return EventScreen();
            }),
        GoRoute(
            path: 'events/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              final event = Provider.of<EventProvider>(context, listen: false)
                  .getEventFromId(id!);
              return EventDetailViewScreen(event: event);
            }),
        GoRoute(
            path: "editEvent/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              final event = Provider.of<EventProvider>(context, listen: false)
                  .getEventFromId(id!);
              return EventScreen(event: event);
            }),
        GoRoute(
            path: "addFilter",
            builder: (context, state) {
              return EventFilterScreen();
            }),
        GoRoute(
            path: "chat/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Chat(eventId: id!);
            }),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFB7CBDD),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFB7CBDD),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

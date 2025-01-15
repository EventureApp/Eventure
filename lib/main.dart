import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/providers/theme_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/auth/elegant_signin_screen.dart';
import 'package:eventure/screens/auth/elegant_signup_screen.dart';
import 'package:eventure/screens/chat/chat_view.dart';
import 'package:eventure/screens/events/create_event_screen.dart';
import 'package:eventure/screens/events/detail_view.dart';
import 'package:eventure/screens/filter/filter_screen.dart';
import 'package:eventure/screens/filter/location_select_screen.dart';
import 'package:eventure/screens/home/home_page.dart';
import 'package:eventure/screens/profile/add_friends.dart';
import 'package:eventure/screens/profile/user_profile.dart';
import 'package:eventure/screens/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:eventure/models/user.dart';
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
          ChangeNotifierProxyProvider<LocationProvider, EventProvider>(
              create: (_) => EventProvider(),
              update: (context, locationProvider, eventProvider) =>
                  EventProvider.withLocation(locationProvider.currentLocation)),
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider())
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
              const PopScope(canPop: false, child: ElegantSignInScreen()),
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
              return const AddFriendsScreen();
            }),
        GoRoute(
            path: "addEvent",
            builder: (context, state) {
              return const EventScreen();
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
              return const EventFilterScreen();
            }),
        GoRoute(
          path: 'settings',
          builder: (context, state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
            path: "chat/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Chat(eventId: id!);
            }),
        GoRoute(
            path: "setLocation",
            builder: (context, state) {
              return const LocationSelectScreen();
            }),
        GoRoute(
          path: "userProfile/:id",
          builder: (context, state) {
            final id = state.pathParameters['id'];
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final user = userProvider.getUser(id!);
            return FutureBuilder<AppUser>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading user profile'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('User not found'));
                } else {
                  return ProfileDetailScreen(user: snapshot.data);
                }
              },
            );
          },
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      // Listen for theme changes
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Eventure',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFFB7CBDD),
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF7F8F9),
              secondary: Colors.black,
              surface: Color(0xFFF1F2F4),
              tertiary: Color(0xFFDCDFE4),
              error: Colors.red,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark, // Set the dark theme
            primaryColor: const Color(0xFFB7CBDD),
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF10151B),
              secondary: Colors.white,
              surface: Color(0xFF1B2936),
              tertiary: Color(0xFF121212),
              error: Colors.red,
            ),
          ),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: _router,
        );
      },
    );
  }
}

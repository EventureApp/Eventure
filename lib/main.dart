import 'package:eventure/models/user.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/events/event-screen.dart';
import 'package:eventure/screens/events/detail_view.dart';
import 'package:eventure/screens/filter/filter-screen.dart';
import 'package:eventure/screens/profile/user_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/home_page.dart';

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
    final isLoggingIn = state.uri.toString() == '/sign-in';

    if (!authProvider.isLoggedIn && !isLoggingIn) {
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
          builder: (context, state) {
            return PopScope(
                canPop: false,
                child: SignInScreen(
                  actions: [
                    ForgotPasswordAction(((context, email) {
                      final uri = Uri(
                        path: '/sign-in/forgot-password',
                        queryParameters: <String, String?>{
                          'email': email,
                        },
                      );
                      context.push(uri.toString());
                    })),
                    AuthStateChangeAction(((context, state) {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      final user = switch (state) {
                        SignedIn state => state.user,
                        UserCreated state => state.credential.user,
                        _ => null
                      };
                      if (user == null) {
                        return;
                      }
                      if (state is UserCreated) {
                        user.updateDisplayName(user.email!.split('@')[0]);
                        AppUser appUser = AppUser(
                            id: user.uid, username: user.email!.split('@')[0]);
                        userProvider.addUser(appUser);
                      }
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            content: Text(
                                'Please check your email to verify your email address'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      context.go('/');
                    })),
                  ],
                ));
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
            path: 'profile',
            builder: (context, state) {
              return Consumer<AuthenticationProvider>(
                  builder: (context, authProvider, _) =>
                      const ProfileDetailScreen());
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
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFFB7CBDD),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFFB7CBDD),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

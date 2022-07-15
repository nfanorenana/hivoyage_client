import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hivoyage/components/splash_screen.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/pages/layout.dart';
import 'package:hivoyage/pages/login.dart';
import 'package:hivoyage/pages/register.dart';
import 'package:hivoyage/providers/auth.dart';
import 'package:hivoyage/providers/user_provider.dart';
import 'package:hivoyage/util/storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
          supportedLocales: const [Locale('fr', 'FR')],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const SplashScreen();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data.token == null) {
                      return const Login();
                    } else {
                      // UserPreferences().removeUser();
                      // return Welcome(user: snapshot.data);
                      return const Layout();
                    }
                }
              },
          ),
          routes: {
            '/home': (context) => const Layout(),
            '/login': (context) => const Login(),
            '/register': (context) => Register(),
          },
      ),
    );
  }
}

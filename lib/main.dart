// main.dart

import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
//         useMaterial3: true,
//       ),
//       home: const NotesScreen(),
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          secondaryContainer: Colors.grey,
          primary: Colors.black,
          surface: Colors.white,
          surfaceVariant: Colors.white,
          onSurface: Colors.black,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initial: await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light,

      builder: (theme, darkTheme) => MaterialApp(
        // supportedLocales: AppLocalizations.supportedLocales,
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        // home: BlocProvider<AuthBloc>(
        //   create: (context) => AuthBloc(FirebaseAuthProvider()),
        //   child: const HomePage(),
        // ),
        // routes: {
        //   createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        // },
        home: const HomePage(),
        routes: {
          notesRoute: (context) => const NotesPage(),
          '/createnote/': (context) => const CreateUpdateNote(),
          // '/route/': (context) => const Scaner(),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        // Firebase.initializeApp(
        //     options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              // final user = FirebaseAuth.instance.currentUser;
              if (user != null && user.isEmailVerified) {
                return const NotesPage();
              } else {
                return const LogInPage();
              }
            default:
              return const CircularProgressIndicator();
          }
        });

    // context.read<AuthBloc>().add(const AuthEventInitialize());
    // return BlocConsumer<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     if (state.isLoading) {
    //       LoadingScreen().show(
    //         context: context,
    //         text: state.loadingText ?? 'Please wait a moment',
    //       );
    //     } else {
    //       LoadingScreen().hide();
    //     }
    //   },
    //   builder: (context, state) {
    //     if (state is AuthStateLoggedIn) {
    //       return const NotesView();
    //     } else if (state is AuthStateNeedsVerification) {
    //       return const VerifyEmailView();
    //     } else if (state is AuthStateLoggedOut) {
    //       return const LoginView();
    //     } else if (state is AuthStateForgotPassword) {
    //       return const ForgotPasswordView();
    //     } else if (state is AuthStateRegistering) {
    //       return const RegisterView();
    //     } else {
    //       return const Scaffold(
    //         body: CircularProgressIndicator(),
    //       );
    //     }
    //   },
    // );
  }
}

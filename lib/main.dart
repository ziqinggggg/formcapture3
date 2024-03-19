// main.dart

import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
        routes: {
          '/createnote/': (context) => const CreateUpdateNote(),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment...');
        } else {
          LoadingScreen().hide;
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesPage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailPage();
        } else if (state is AuthStateLSignedOut) {
          return const LogInPage();
          // } else if (state is AuthStateForgotPassword) {
          //   return const ForgotPasswordView();
        } else if (state is AuthStateSigningUp) {
          return const SignUpPage();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

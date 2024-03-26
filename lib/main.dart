// main.dart

import 'package:formcapture/imports.dart';

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
          child: HomeScreen(),
        ),
        routes: {
          '/createentry/': (context) => const CreateUpdateEntry(),
        },
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Loading...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const EntriesScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailScreen();
        } else if (state is AuthStateSignedOut) {
          return const LogInScreen();
        } else if (state is AuthStateForgotPassword) {
          return const ResetPassworScreen();
        } else if (state is AuthStateSigningUp) {
          return const SignUpScreen();
        } else {
          // if (state.isLoading) {
          //   LoadingScreen().show(
          //       context: context,
          //       text: state.loadingText ?? 'Pleasess wait a moment...');
          //       return Container();
          // } else {
          //   LoadingScreen().hide();
          //   return Container();
          //   }

          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

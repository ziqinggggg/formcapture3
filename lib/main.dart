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
          child: HomePage(),
        ),
        routes: {
          '/createnote/': (context) => const CreateUpdateNote(),
          // '/forminput/': (context) => const InputForm(path),
        },
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
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
          return const NotesPage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailPage();
        } else if (state is AuthStateSignedOut) {
          return const LogInPage();
        } else if (state is AuthStateForgotPassword) {
          return const ResetPasswordPage();
        } else if (state is AuthStateSigningUp) {
          return const SignUpPage();
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

// import 'dart:convert';

// import 'package:expandable_datatable/expandable_datatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:developer' as devtools show log;

// import 'package:formcapture/models.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//       theme: ThemeData.light(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Users> userList = [];

//   late List<ExpandableColumn<dynamic>> headers;
//   late List<ExpandableRow> rows;

//   bool _isLoading = true;

//   void setLoading() {
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     fetch();
//   }

//   void fetch() async {
//     userList = await getUsers();

//     createDataSource();

//   }

//   Future<List<Users>> getUsers() async {
//     final String response = await rootBundle.loadString('asset/dumb.json');

//     final data = await json.decode(response);

//     API apiData = API.fromJson(data);

//     if (apiData.users != null) {
//       devtools.log('userList' + apiData.users!.toString());

//       return apiData.users!;
//     }

//     return [];
//   }

//   void createDataSource() {
//     headers = [
//       ExpandableColumn<int>(columnTitle: "ID", columnFlex: 1),
//       ExpandableColumn<String>(columnTitle: "First name", columnFlex: 2),
//       ExpandableColumn<String>(columnTitle: "Last name", columnFlex: 2),
//       ExpandableColumn<String>(columnTitle: "Maiden name", columnFlex: 2),
//       ExpandableColumn<int>(columnTitle: "Age", columnFlex: 1),
//       ExpandableColumn<String>(columnTitle: "Gender", columnFlex: 1),
//       ExpandableColumn<String>(columnTitle: "Email", columnFlex: 4),
//     ];

//     devtools.log('headers' + headers.toString());

//     rows = userList.map<ExpandableRow>((e) {
//       return ExpandableRow(cells: [
//         ExpandableCell<int>(columnTitle: "ID", value: e.id),
//         ExpandableCell<String>(columnTitle: "First name", value: e.firstName),
//         ExpandableCell<String>(columnTitle: "Last name", value: e.lastName),
//         ExpandableCell<String>(columnTitle: "Maiden name", value: e.maidenName),
//         ExpandableCell<int>(columnTitle: "Age", value: e.age),
//         ExpandableCell<String>(columnTitle: "Gender", value: e.gender),
//         ExpandableCell<String>(columnTitle: "Email", value: e.email),
//       ]);
//     }).toList();
//     devtools.log('rows' + rows.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: !_isLoading
//             ? LayoutBuilder(builder: (context, constraints) {
//                 int visibleCount = 3;
//                 if (constraints.maxWidth < 600) {
//                   visibleCount = 3;
//                 } else if (constraints.maxWidth < 800) {
//                   visibleCount = 4;
//                 } else if (constraints.maxWidth < 1000) {
//                   visibleCount = 5;
//                 } else {
//                   visibleCount = 6;
//                 }

//                 return ExpandableTheme(
//                   data: ExpandableThemeData(
//                     context,
//                     contentPadding: const EdgeInsets.all(20),
//                     expandedBorderColor: Colors.transparent,
//                     paginationSize: 48,
//                     headerHeight: 56,
//                     headerColor: Colors.amber[400],
//                     headerBorder: const BorderSide(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     evenRowColor: const Color(0xFFFFFFFF),
//                     oddRowColor: Colors.amber[200],
//                     rowBorder: const BorderSide(
//                       color: Colors.black,
//                       width: 0.3,
//                     ),
//                     rowColor: Colors.green,
//                     headerTextMaxLines: 4,
//                     headerSortIconColor: const Color(0xFF6c59cf),
//                     paginationSelectedFillColor: const Color(0xFF6c59cf),
//                     paginationSelectedTextColor: Colors.white,
//                   ),
//                   child: ExpandableDataTable(
//                     headers: headers,
//                     rows: rows,
//                     multipleExpansion: false,
//                     isEditable: false,
//                     onRowChanged: (newRow) {
//                       print(newRow.cells[01].value);
//                     },
//                     onPageChanged: (page) {
//                       print(page);
//                     },
//                     renderEditDialog: (row, onSuccess) =>
//                         _buildEditDialog(row, onSuccess),
//                     visibleColumnCount: visibleCount,
//                   ),
//                 );
//               })
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   Widget _buildEditDialog(
//       ExpandableRow row, Function(ExpandableRow) onSuccess) {
//     return AlertDialog(
//       title: SizedBox(
//         height: 300,
//         child: TextButton(
//           child: const Text("Change name"),
//           onPressed: () {
//             row.cells[1].value = "x3";
//             onSuccess(row);
//           },
//         ),
//       ),
//     );
//   }
// }

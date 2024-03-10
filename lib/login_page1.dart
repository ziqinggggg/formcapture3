// import 'package:formcapture/pages.dart';

// class LogInScreen extends StatefulWidget {
//   const LogInScreen({super.key});

//   @override
//   State<LogInScreen> createState() => _LogInState();
// }

// class _LogInState extends State<LogInScreen> {
//   final _formKey = GlobalKey<FormState>();
//   // final _email = TextEditingController();
//   // final _password = TextEditingController();

//   // Future signIn() async {
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return const Center(
//   //           child: CircularProgressIndicator(),
//   //         );
//   //       });

//   //   await FirebaseAuth.instance.signInWithEmailAndPassword(
//   //       email: _email.text.trim(),
//   //       password: _password.text.trim());
//   // }

//   late final TextEditingController _email;
//   late final TextEditingController _password;

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();

//     super.initState();
//   }

//   bool showPassword = false;

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return SingleChildScrollView(
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Column(
//                       key: _formKey,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           height: 230,
//                         ),
//                         const Text(
//                           'Welcome',
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           height: 50,
//                           margin: const EdgeInsets.only(bottom: 15),
//                           decoration: const BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                           child: TextFormField(
//                             controller: _email,
//                             enableSuggestions: false,
//                             autocorrect: false,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: const InputDecoration(
//                               hintText: 'Enter your email here',
//                               prefixIcon: Icon(
//                                 Icons.email_outlined,
//                               ),
//                               border: UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value != null) {
//                                 if (value.isEmpty) {
//                                   return "Please enter an email";
//                                 }
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         Container(
//                           height: 50,
//                           margin: const EdgeInsets.only(bottom: 15),
//                           decoration: const BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                           child: TextFormField(
//                             controller: _password,
//                             enableSuggestions: false,
//                             autocorrect: false,
//                             obscureText: !showPassword,
//                             validator: (value) {
//                               if (value != null) {
//                                 if (value.isEmpty) {
//                                   return "Please enter your password";
//                                 }
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                               border: const UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                               ),
//                               hintText: 'Enter your password here',
//                               prefixIcon: const Icon(
//                                 Icons.lock_outline,
//                               ),
//                               suffixIcon: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     showPassword = !showPassword;
//                                   });
//                                 },
//                                 child: showPassword
//                                     ? const Icon(
//                                         Icons.visibility_off,
//                                       )
//                                     : const Icon(
//                                         Icons.visibility,
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20))),
//                               onPressed: () async {
//                                 final email = _email.text;
//                                 final password = _password.text;
//                                 try {
//                                   FirebaseAuth.instance
//                                       .signInWithEmailAndPassword(
//                                           email: email, password: password);
//                                   // print(userCredential);
//                                 } on FirebaseAuthException catch (e) {
//                                   if (e.code == 'user-not-found') {
//                                     print('User not found.');
//                                   }
//                                 }
//                               },
//                               child: const Text(
//                                 'Login',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                 ),
//                               )),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.black26,
//                                 thickness: 1,
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Text(
//                                 'OR',
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black54),
//                               ),
//                             ),
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.black26,
//                                 thickness: 1,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: ListTile(
//                               leading: Image.asset(
//                                 'assets/images/google.png',
//                                 height: 25,
//                               ),
//                               title: const Text('Continue with Google',
//                                   style: TextStyle(fontSize: 16)),
//                             )),
//                         const SizedBox(
//                           height: 105,
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const SignUpScreen()));
//                           },
//                           child: RichText(
//                             text: const TextSpan(
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 16),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                   text: 'Don\'t have an account? ',
//                                 ),
//                                 TextSpan(
//                                     text: 'Sign up',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             default:
//               return const Text('Loading...');
//           }
//         },
//       ),
//     );
//   }
// }

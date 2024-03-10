// import 'package:formcapture/pages.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   // final _username = TextEditingController();
//   // final _email = TextEditingController();
//   // final _password = TextEditingController();
//   // final _confirmPassword = TextEditingController();

//   late final TextEditingController _username;
//   late final TextEditingController _email;
//   late final TextEditingController _password;

//   @override
//   void initState() {
//     _username = TextEditingController();
//     _email = TextEditingController();
//     _password = TextEditingController();

//     super.initState();
//   }

//   bool showPassword = false;

//   @override
//   void dispose() {
//     _username.dispose();
//     _email.dispose();
//     _password.dispose();
//     // _confirmPassword.dispose();
//     super.dispose();
//   }

//   // bool passwordsMatch() {
//   //   if (_password.text.trim() ==
//   //       _confirmPassword.text.trim()) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }

//   Future signUp() async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     if (passwordsMatch()) {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _email.text.trim(), password: _password.text.trim());
//     }

//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => const NotesScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Column(
//               key: _formKey,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 230,
//                 ),
//                 const Text(
//                   'Sign up',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 50,
//                   margin: const EdgeInsets.only(bottom: 15),
//                   // padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                   child: TextFormField(
//                     controller: _username,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Username',
//                       prefixIcon: Icon(
//                         Icons.person_outline,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value != null) {
//                         if (value.isEmpty) {
//                           return "Please enter your username";
//                         }
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 Container(
//                   height: 50,
//                   margin: const EdgeInsets.only(bottom: 15),
//                   // padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                   child: TextFormField(
//                     controller: _email,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Email',
//                       prefixIcon: Icon(
//                         Icons.email_outlined,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value != null) {
//                         if (value.isEmpty) {
//                           return "Please enter your email";
//                         }
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 Container(
//                   height: 50,
//                   margin: const EdgeInsets.only(bottom: 15),
//                   // padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                   child: TextFormField(
//                     obscureText: !showPassword,
//                     controller: _password,
//                     validator: (value) {
//                       if (value != null) {
//                         if (value.isEmpty) {
//                           return "Please enter your password";
//                         }
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Password',
//                       prefixIcon: const Icon(
//                         Icons.lock_outlined,
//                       ),
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           setState(() {
//                             showPassword = !showPassword;
//                           });
//                         },
//                         child: showPassword
//                             ? const Icon(
//                                 Icons.visibility_off,
//                               )
//                             : const Icon(
//                                 Icons.visibility,
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Container(
//                 //   height: 50,
//                 //   margin: const EdgeInsets.only(bottom: 15),
//                 //   padding: const EdgeInsets.symmetric(horizontal: 10),
//                 //   decoration: const BoxDecoration(
//                 //     border: Border(
//                 //       bottom: BorderSide(color: Colors.grey),
//                 //     ),
//                 //   ),
//                 //   child: TextFormField(
//                 //     obscureText: !showPassword,
//                 //     controller: _confirmPasswordController,
//                 //     validator: (value) {
//                 //       if (value != null) {
//                 //         if (value.isEmpty) {
//                 //           return "Please confirm your password";
//                 //         }
//                 //       }
//                 //       return null;
//                 //     },
//                 //     decoration: InputDecoration(
//                 //       suffixIcon: InkWell(
//                 //         onTap: () {
//                 //           setState(() {
//                 //             showPassword = !showPassword;
//                 //           });
//                 //         },
//                 //         child: showPassword
//                 //             ? const Icon(
//                 //                 Icons.visibility_off,
//                 //               )
//                 //             : const Icon(
//                 //                 Icons.visibility,
//                 //               ),
//                 //       ),
//                 //       border: InputBorder.none,
//                 //       hintText: 'Confirm password',
//                 //       prefixIcon: Icon(
//                 //         Icons.lock_outlined,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20))),
//                       onPressed: () async {
//                         final username = _username.text;
//                         final email = _email.text;
//                         final password = _password.text;
//                       },
//                       child: const Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       )),
//                 ),
//                 const SizedBox(
//                   height: 160,
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LogInScreen()));
//                   },
//                   child: RichText(
//                     text: const TextSpan(
//                       style: TextStyle(color: Colors.black, fontSize: 16),
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: 'Already have an account? ',
//                         ),
//                         TextSpan(
//                             text: 'Log in',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

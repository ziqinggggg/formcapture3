// import 'package:formcapture/imports.dart';

// Future<void> showVerifyEmailMenu(context, String message) {
//   StreamController<int> _timerStream = StreamController<int>();
//   late Timer resendCodeTimer;
//   const timerDuration = 30;

//   activeCounter() {
//     resendCodeTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (timerDuration - timer.tick > 0) {
//         _timerStream.sink.add(timerDuration - timer.tick);
//       } else {
//         _timerStream.sink.add(0);
//         resendCodeTimer.cancel();
//       }
//     });
//   }

//   activeCounter();

//   return showModalBottomSheet<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           StreamBuilder<Object>(
//               stream: _timerStream.stream,
//               builder: (context, snapshot) {
//                 return SizedBox(
//                   height: 240,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(message,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                               textAlign: TextAlign.center),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 132, 128, 128),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20)),
//                             side: const BorderSide(color: Colors.grey),
//                             fixedSize: const Size.fromHeight(50),
//                           ),
//                           onPressed: snapshot.data == 0
//                               ? () async {
//                                   context.read<AuthBloc>().add(
//                                         const AuthEventSendEmailVerification(),
//                                       );
//                                   _timerStream.sink.add(30);
//                                   activeCounter();
//                                 }
//                               : null,
//                           child: Text(
//                             snapshot.data == 0
//                                 ? 'Resend Email Verification'
//                                 : 'Resend Email Verification in ${snapshot.hasData ? snapshot.data.toString() : 30}s',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                           // final user = FirebaseAuth.instance.currentUser;
//                           // await user?.sendEmailVerification();
//                           // await AuthService.firebase().sendEmailVerification();
//                         ),
//                         //     const SizedBox(
//                         //       width: 40,
//                         //     ),
//                         //     ElevatedButton(
//                         //       style: ElevatedButton.styleFrom(
//                         //         backgroundColor: Colors.white,
//                         //         shape: RoundedRectangleBorder(
//                         //             borderRadius: BorderRadius.circular(20)),
//                         //         side: const BorderSide(color: Colors.grey),
//                         //         fixedSize: const Size.fromHeight(50),
//                         //       ),
//                         //       child: const Text(
//                         //         'Login now',
//                         //         style: TextStyle(
//                         //           color: Colors.black,
//                         //           fontSize: 16,
//                         //         ),
//                         //       ),
//                         //       onPressed: () async {
//                         //         Navigator.push(
//                         //           context,
//                         //           MaterialPageRoute(
//                         //             builder: (context) => const LogInPage(),
//                         //           ),
//                         //         );
//                         //       },
//                         //     )
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                   ),
//                 );
//               });
//         },
//       );
//     },
//   );
// }

// import 'package:formcapture/pages.dart';

// class LogInScreen extends StatefulWidget {
//   const LogInScreen({super.key});

//   @override
//   State<LogInScreen> createState() => _LogInState();
// }

// class _LogInState extends State<LogInScreen> {
//   final _formKey = GlobalKey<FormState>();

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
//               children: const [
//                 SizedBox(
//                   height: 270,
//                 ),
//                 Text(
//                   'FormCapture',
//                   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 LogInButton(
//                     imageUrl: 'assets/images/google.png',
//                     signInMethod: 'Google'),
//                 LogInButton(
//                     imageUrl: 'assets/images/facebook.png',
//                     signInMethod: 'Facebook'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LogInButton extends StatelessWidget {
//   final String imageUrl;
//   final String signInMethod;
//   const LogInButton({
//     Key? key,
//     required this.imageUrl,
//     required this.signInMethod,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(20)),
//         child: ListTile(
//           leading: Image.asset(
//             imageUrl,
//             height: 25,
//           ),
//           title: Text('Continue with $signInMethod',
//               style: const TextStyle(fontSize: 16)),
//         ));
//   }
// }

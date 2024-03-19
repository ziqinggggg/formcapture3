// !converting list to map

// import 'package:flutter/material.dart';
// import 'package:formcapture/imports.dart';

// class InputForm extends StatefulWidget {
//   @override
//   _InputFormState createState() => _InputFormState();
// }

// class _InputFormState extends State<InputForm> {
//   Map<String, TextEditingController> textFields = {};
//   List<TextEditingController> controllers = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers for default text fields
//     for (int i = 0; i < 3; i++) {
//       controllers.add(TextEditingController());
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose controllers
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _addTextField() {
    
//     setState(() {
//       controllers.add(TextEditingController());
//     });
//   }

//   void _removeTextField(int index) {
//     setState(() {
//       controllers.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Form',
//           style: TextStyle(
//             fontSize: 35,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: <Widget>[
//           // Display existing text fields
//           for (int i = 0; i < controllers.length; i++)
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controllers[i],
//                     decoration: InputDecoration(
//                       labelText: 'Input Field ${i + 1}',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.remove_circle_outline_rounded,
//                     color: Colors.red,
//                   ),
//                   onPressed: () {
//                     if (controllers.length > 1) {
//                       _removeTextField(i);
//                     } else {
//                       showErrorDialog(
//                           context, 'Form field should be more than one');
//                     }
//                   },
//                 ),
//               ],
//             ),
//           const SizedBox(height: 30.0),
//           // Button to add new text field
//           SizedBox(
//             height: 55,
//             child: ElevatedButton(
//               onPressed: _addTextField,
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 31, 31, 31),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//               child: const Text(
//                 'Add Field',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   backgroundColor: Theme.of(context).brightness == Brightness.light
//       //       ? Colors.black
//       //       : Colors.grey.shade800,
//       //   child: const Icon(
//       //     Icons.add,
//       //     color: Colors.white,
//       //   ),
//       //   onPressed: () {},
//       // ),
//     );
//   }
// }

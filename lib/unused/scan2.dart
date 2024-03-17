// // scan.dart

// import 'package:formcapture/imports.dart';

// import 'package:camera/camera.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class ScanPage extends StatefulWidget {
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   late final Future<void> _cameraPermissionFuture;
//   late CameraController _cameraController;
//   final TextRecognizer textRecognizer = TextRecognizer();

//   @override
//   void initState() {
//     super.initState();
//     _cameraPermissionFuture = _requestCameraPermission();
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     textRecognizer.close();
//     super.dispose();
//   }

//   Future<bool> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     return status == PermissionStatus.granted;
//   }

//   void _initCameraController(CameraDescription camera) {
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.max,
//       enableAudio: false,
//     );
//     _cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   Future<void> _scanImage(BuildContext context) async {
//     try {
//       final pictureFile = await _cameraController.takePicture();
//       final file = File(pictureFile.path);
//       final inputImage = InputImage.fromFile(file);
//       final recognizedText = await textRecognizer.processImage(inputImage);

//       Navigator.pop(context, recognizedText.text);

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred when scanning text'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Text'),
//       ),
//       body: FutureBuilder(
//         future: _cameraPermissionFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done &&
//               snapshot.hasData) {
//             return CameraPreview(_cameraController);
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

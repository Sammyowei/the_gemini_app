// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:the_gemini_app/main.dart';
// import 'package:the_gemini_app/src/data/constants/constants.dart';
// import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';

// class DocumentCaptureScreen extends StatefulWidget {
//   const DocumentCaptureScreen({super.key});

//   @override
//   State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
// }

// class _DocumentCaptureScreenState extends State<DocumentCaptureScreen> {
//   late CameraController _cameraController;

//   @override
//   void initState() {
//     super.initState();

//     _cameraController = CameraController(
//       camera[0],
//       ResolutionPreset.max,
//     );

//     _cameraController.initialize().then(
//       (_) {
//         if (!mounted) {
//           return;
//         }
//       },
//     ).catchError((err) {
//       if (err is CameraException) {
//         switch (err.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const GeminiAppWidget(),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Container(
//               color: Colors.black,
//               height: size.height,
//               width: size.width,
//               child: CameraPreview(_cameraController)),
//           CustomPaint(
//             size: size,
//             painter: MasterPainter(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MasterPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF35383F).withOpacity(0.9)
//       ..style = PaintingStyle.fill;

//     // Create a path for the entire canvas
//     final backgroundPath = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

//     // Create a path for the inner rectangle
//     final innerRectPath = Path();
//     final innerRect = Rect.fromCenter(
//       center: Offset(size.width / 2, size.height / 2),
//       width: size.width * 0.95,
//       height: size.height * 0.35,
//     );
//     innerRectPath.addRRect(
//         RRect.fromRectAndRadius(innerRect, const Radius.circular(20)));

//     // Combine the paths to create a hole in the background
//     final combinedPath = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       innerRectPath,
//     );

//     // Draw the semi-transparent overlay
//     canvas.drawPath(combinedPath, paint);

//     // Draw the border of the inner rectangle
//     final borderPaint = Paint()
//       ..color = Colors.blueGrey
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;
//     canvas.drawPath(innerRectPath, borderPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

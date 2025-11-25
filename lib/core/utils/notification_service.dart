// import 'package:flutter/material.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   Future<void> init() async {
//     // Simplified initialization without flutter_local_notifications
//     print('Notification service initialized');
//   }

//   // Show in-app alert using SnackBar
//   static void showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   // Show in-app alert using Dialog
//   static Future<void> showAlertDialog(
//     BuildContext context, {
//     required String title,
//     required String message,
//   }) async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Simple console log for background alerts
//   void logAlert(String title, String body) {
//     print('WEATHER ALERT: $title - $body');
//   }
// }
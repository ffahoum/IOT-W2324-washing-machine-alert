import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './components/foreground_notification_dialog.dart';
import './pages/auth_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', 
  importance: Importance.high,
);


Future<void> initLocalNotifications() async {
  final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging fcm = FirebaseMessaging.instance;


  @override initState() {
    fcm.requestPermission();
    initLocalNotifications();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null &&
          message.notification!.title != null &&
          message.notification!.body != null) {
        // Handle foreground notifications
        showForegroundNotificationDialog(message.notification!);
      }
    });
    super.initState();
  }


void showForegroundNotificationDialog(RemoteNotification notification) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ForegroundNotificationDialog(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
 
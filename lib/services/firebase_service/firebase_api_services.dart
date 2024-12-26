import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message);
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

class FirebaseAPIServices {
  BaseController baseCtrl = Get.put(BaseController());

  final fbMessaging = FirebaseMessaging.instance;
  AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed('/home', arguments: message);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      // final notification = event.notification;
      // if(notification == null) return;

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null) {
        // if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print("notificationResponse.payload");
        print(notificationResponse.payload);
        final message = RemoteMessage.fromMap(
            json.decode(notificationResponse.payload.toString()));
        handleMessage(message);

        //   switch (notificationResponse.notificationResponseType) {
        //     case NotificationResponseType.selectedNotification:
        //       selectNotificationStream.add(notificationResponse.payload);
        //       break;
        //     case NotificationResponseType.selectedNotificationAction:
        //       if (notificationResponse.actionId == navigationActionId) {
        //         selectNotificationStream.add(notificationResponse.payload);
        //       }
        //       break;
        //   }
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final platform = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(androidChannel);
  }

  Future<void> initNotifications() async {
    await fbMessaging.requestPermission();
    final fcmToken = await fbMessaging.getToken();
    baseCtrl.fbUserId = fcmToken;

    print("Token : $fcmToken");
    // d83y3TzSTqSdEEffciHCFP:APA91bHeqjrDutelfPoTpLNvfUArEvcmLy8I59KWQBal5PPVp35EozcvSq0vI1GUWC773FOyOnCYNf35NkeEYgW0W9E82U5lU3y_er_ZPOORccauV9GnivgBlSlhSO5rNKB9k4Tk4wx8
    initPushNotifications();
    initLocalNotifications();
  }

// Future<void> sendNotification(String fcmToken, String title, String body) async {
//   final response = await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your server key
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': body,
//           'title': title,
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           'id': '1',
//           'status': 'done',
//         },
//         'to': fcmToken,
//       },
//     ),
//   );

//   if (response.statusCode == 200) {
//     print('Notification sent successfully');
//   } else {
//     print('Failed to send notification. Error: ${response.reasonPhrase}');
//   }
// }
}

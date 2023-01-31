import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart'as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}


class _TestState extends State<Test> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool isFlutterLocalNotificationsInitialized = false;



  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }


  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }





  String _token="f9Lhq_CqQI22oEm5ebxk7h:APA91bEG8kQiZWhbbUUk6lbe7UJPvi4if-wbDyja1KoCwVuKl86DxRdQO4z3Xzl-6B2BBy_yg1Rw6XzOfKE982O9m8AvwzsFIKICUU-nfwzKKFxS3eZmV7Rrmjd1pzWvHC2Q6tKpRhE3";

  int _messageCount = 0;

  String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }




  Future<void> sendPushMessage(String body, String text) async{
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAALo3lUPY:APA91bHh8nyfFofXjDTv9yUPpg1PYMQjaBqTAqu8YPxv3VwfG8DlROakm4la0oVi6TRbBq0hdXxkMUX02Wi60GqBRTh_C9yHYlGTjGd4QsR9v6GvxxNC5PNmQXY3hsEu9f2yY6KJeINC',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': text},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
            },
            "to": _token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken()async{
    await FirebaseMessaging.instance.getToken().then((value) => print(value));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupFlutterNotifications();
    getToken();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.instance.subscribeToTopic("Animal");

  }

  TextEditingController _bodyController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                hintText: "Body"
              ),
            ),
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                  hintText: "Text"
              ),

            ),
            FloatingActionButton(onPressed: () {
              String body = _bodyController.text.trim();
              String text = _textController.text.trim();
              sendPushMessage(body, text);
            },
            child: Icon(Icons.add),),
          ],
        ),
      ),
    );
  }
}

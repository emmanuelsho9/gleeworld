// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'main.dart';
//
// class MyHomePageState extends State<MyHomePage> {
//   TextEditingController _UserController = TextEditingController();
//   TextEditingController _bodyController = TextEditingController();
//   TextEditingController _titleController = TextEditingController();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   String? mtoken = "";
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     requestPermission();
//     getToken();
//     initInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             TextFormField(
//               controller: _UserController,
//               decoration: InputDecoration(hintText: "User name"),
//             ),
//             TextFormField(
//               controller: _bodyController,
//               decoration: InputDecoration(hintText: "Body"),
//             ),
//             TextFormField(
//               controller: _titleController,
//               decoration: InputDecoration(hintText: "Title"),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             InkWell(
//               onTap: () async {
//                 String nameText = _UserController.text.trim();
//                 String bodyText = _bodyController.text.trim();
//                 String titleText = _titleController.text.trim();
//
//                 if(nameText !=""){
//                   DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UsersToken").doc(nameText).get();
//                   String token = snap["token"];
//                   print(token);
//
//
//                   sendPushMessage(token,titleText , bodyText);
//                 }
//               },
//               child: Container(
//                   width: double.infinity,
//                   height: 50,
//                   color: Colors.red,
//                   child: const Center(
//                       child: Text(
//                     "Submit",
//                     style: TextStyle(color: Colors.white),
//                   ))),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true);
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted permission");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print("User granted provisional permission");
//     } else {
//       print("User declined or didn't accept  permission");
//     }
//   }
//
//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) {
//       setState(() {
//         mtoken = value;
//         print("This is my mobile device $mtoken");
//       });
//       saveToken(value!);
//     });
//   }
//
//   void saveToken(String value) {
//     FirebaseFirestore.instance.collection("UsersToken").doc("User1").set({
//       "token": value,
//     });
//   }
//
//   void initInfo() {
//     var androidInitialize =
//         const AndroidInitializationSettings("assets/ic_launcher.png");
//     var IOSInitialize = const IOSInitializationSettings();
//     var initializationSettings =
//         InitializationSettings(android: androidInitialize, iOS: IOSInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//       try {
//         if (payload != null) {
//         } else {}
//       } catch (e) {}
//       return;
//     });
//     FirebaseMessaging.onBackgroundMessage((message) async {
//       print("........................onMessage.................");
//       print(
//           "onMessage: ${message.notification?.title}/${message.notification?.body}");
//
//       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//         message.notification!.body.toString(),
//         htmlFormatBigText: true,
//         contentTitle: message.notification!.title.toString(),
//         htmlFormatContentTitle: true,
//       );
//
//       AndroidNotificationDetails androidNotificationDetails =
//           AndroidNotificationDetails("2", "2",
//               importance: Importance.high,
//               styleInformation: bigTextStyleInformation,
//               priority: Priority.high,
//               playSound: true);
//
//       NotificationDetails platformChannelSpecific = NotificationDetails(
//           android: androidNotificationDetails,
//           iOS: const IOSNotificationDetails());
//
//
//        // await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
//        //     message.notification?.body, platformChannelSpecific,
//        //     payload: message.data["body"]
//        // );
//
//     });
//   }
//
//   Future<void> sendPushMessage(String token, String titleText, String bodyText) async {
//     try{
//       await http.post(
//           Uri.parse("https://fcm.googleapis.com/fcm/send"),
//           headers: <String, String>{
//             "Content-Type":"application/json",
//             "Authorization":"key=AAAALo3lUPY:APA91bHh8nyfFofXjDTv9yUPpg1PYMQjaBqTAqu8YPxv3VwfG8DlROakm4la0oVi6TRbBq0hdXxkMUX02Wi60GqBRTh_C9yHYlGTjGd4QsR9v6GvxxNC5PNmQXY3hsEu9f2yY6KJeINC"
//           },
//           body: jsonEncode(
//               <String, dynamic>
//               {
//             "priority":"high",
//             "data":<String, dynamic>{
//               "click_action":"FLUTTER_NOTIFICATION_CLICK",
//               "status":"done",
//               "body":bodyText,
//               'postid': 'Mi6Y3sE9E0uz4uAvQjwC',
//               'type': 'noti',
//               "title":titleText
//             },
//             "notification":<String, dynamic>{
//               "title":titleText,
//               "body":bodyText,
//               "android_channel_id":"2"
//             },
//             "to":token
//           })
//       );
//     }catch (e){
//       if (kDebugMode) {
//         print("heloooooooooo$e");
//       }
//     }
//   }
//
// }

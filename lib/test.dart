import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class Test extends StatefulWidget {
  Test({Key? key, required this.taskName}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
  String taskName;
}

class _TestState extends State<Test> {
  String fetchBackground = "fetchBackground";

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setupFlutterNotifications();
    // ahd();
    getToken();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  TextEditingController _bodyController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  TextEditingController _CapsulesController = TextEditingController();
  TextEditingController _DosageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  int mselectedValue = 0;
  int aselectedValue = 0;
  int nselectedValue = 0;

  String test = "";
  String Uout = "";
  bool cheOut = false;

  result() async {
    int Capsulesvalue;
    int Dosagesvalue;
    final prefs = await SharedPreferences.getInstance();

    var Capsules = _CapsulesController.text.trim();
    var Dosage = _DosageController.text.trim();
    var perP = mselectedValue + aselectedValue + nselectedValue;
    Capsulesvalue = int.parse(Capsules);
    Dosagesvalue = int.parse(Dosage);
    // print(perP);
    int dtotal = perP * Dosagesvalue;
    int totaln = Capsulesvalue - dtotal;

    int Scount = totaln;
    while (Scount >= 0) {
      print(Scount);
      setState(()  {
        test = "Your have ${Scount.toString()} dosage Left Tomorrow";
        String noLeft = Scount.toString();
        work(noLeft);

        if (Scount <= 21) {
          cheOut = true;
        }
      });
      //await prefs.setString('counter', test);

      Scount = Scount - dtotal;

      await Future.delayed(const Duration(minutes: 1));
    }

    print(totaln);
  }



  @override
  Widget build(BuildContext context) {
    var dropdownValue;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed:whatsappConn,
          child: Image.asset("assets/whatsapplogo.png")),
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerDrop(
              onTap: () {},
              radius: 10,
              icon: Icons.calendar_month,
              IcononPressed: () async {
                DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF7F23A8), // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: Color.fromARGB(
                                255, 66, 125, 145), // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: Color(0xFF7F23A8), // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                      ;
                    },
                    lastDate: DateTime(3000));

                if (dateTime != null) {
                  setState(() {
                    _selectedDate = dateTime;
                  });
                }
              },
              Textdata:
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              color: Colors.black,
              fontWeight: FontWeight.w400,
              Boxcolor: Colors.white,
              fontSize: 16,
            ),
            // TextFormField(
            //   controller: _bodyController,
            //   decoration: const InputDecoration(hintText: "Name of drug"),
            // ),
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(hintText: "Name of drug"),
            ),
            TextFormField(
              controller: _CapsulesController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "Total Capsules"),
            ),
            Row(
              children: [
                Checkbox(
                  value: mselectedValue == 1,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == true) {
                        mselectedValue = 1;
                      } else {
                        mselectedValue = 0;
                      }
                    });
                  },
                ),
                Text("Morning"),
                Checkbox(
                  value: aselectedValue == 1,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == true) {
                        aselectedValue = 1;
                      } else {
                        aselectedValue = 0;
                      }
                    });
                  },
                ),
                Text("Afternoon"),
                Checkbox(
                  value: nselectedValue == 1,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == true) {
                        nselectedValue = 1;
                      } else {
                        nselectedValue = 0;
                      }
                    });
                  },
                ),
                Text("Night"),
              ],
            ),
            TextFormField(
              controller: _DosageController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "Dosage"),
            ),
            ElevatedButton(onPressed: result, child: const Text("Result")),
            cheOut == false
                ? Text(
                    test,
                    style: const TextStyle(fontSize: 25),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          "Your drug are almost Out ",
                          style: TextStyle(fontSize: 25, color: Colors.red),
                        ),
                      ),
                      Text(
                        test,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  whatsappConn() async {
    const link = "https://wa.me/message/WRU6GDJ7ZIGLP1";
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
        "Chat with Gleeworld Pharmacy $link",
        subject: "Chat with Gleeworld Pharmacy",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  work(String body2) {
    // Workmanager().registerPeriodicTask(DateTime.now().second.toString(), "fetchBackground",
    //     // When no frequency is provided the default 15 minutes is set.
    //     // M                  // constraints: Constraints(networkType: NetworkType.connected));inimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    //     frequency: const Duration(seconds: 15));
    String body = _bodyController.text.trim();
    String text = _textController.text.trim();

    final cron = Cron();
    cron.schedule(Schedule.parse("*/1 * * * *"), () async {
      // print("object");
      sendPushMessage(text, body2);
    });
  }

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
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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

  String _token =
      "f9Lhq_CqQI22oEm5ebxk7h:APA91bEG8kQiZWhbbUUk6lbe7UJPvi4if-wbDyja1KoCwVuKl86DxRdQO4z3Xzl-6B2BBy_yg1Rw6XzOfKE982O9m8AvwzsFIKICUU-nfwzKKFxS3eZmV7Rrmjd1pzWvHC2Q6tKpRhE3";

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

  Future<void> sendPushMessage(String body, String text) async {
    int sendBefore =
        DateTime.now().add(const Duration(seconds: 5)).millisecondsSinceEpoch;
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
            'notification': <String, dynamic>{
              'body': "Gleeworld is saying your drug ${body} remain ${text}",
              'title': "Hi, Emmanuel, Time to use your Drug"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
            },
            'send_before': sendBefore,
            "to": _token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) => print(value));
  }
}

class ContainerDrop extends StatelessWidget {
  ContainerDrop(
      {Key? key,
      this.Boxcolor,
      required this.radius,
      required this.Textdata,
      this.fontWeight,
      this.color,
      this.fontSize,
      this.IcononPressed,
      required this.icon,
      this.onTap});
  Color? Boxcolor;
  double radius;
  String Textdata;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  Function()? onTap;
  IconData? icon;
  Function()? IcononPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Boxcolor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0xFF7F23A8))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$Textdata",
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: fontWeight, color: color),
                ),
                IconButton(onPressed: IcononPressed, icon: Icon(icon))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

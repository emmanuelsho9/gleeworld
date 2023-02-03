import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gleeworld/test.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:workmanager/workmanager.dart';
import 'HomePage.dart';
import 'firebase_options.dart';


Future<void>_firebaseMessageBackgroundHandler(RemoteMessage message)async{
  print("Handler a background message ${message.messageId}");
}
String fetchBackground = "fetchBackground";





// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     if (taskName == fetchBackground) {
//       print("Testing Background");
//       //work();
//     }
//     return Future.value(true);
//   });
// }




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
   // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Test(taskName: fetchBackground,),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => MyHomePageState();
// }





// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
//
//
// Future<void>_increament()async{
//   final SharedPreferences preferences = await SharedPreferences.getInstance();
//   final int counter = (preferences.getInt("counter")??0)+1;
//   await preferences.setInt("counter", counter);
// }
//
// String fetchBackground = "fetchBackground";
//
// void callbackDispatcher(){
//   Workmanager().executeTask((taskName, inputData)async{
//
//
//     if (taskName == fetchBackground) {
//        print("Testing Background");
//        log("it is a backgroun activity");
//        await _increament();      }
//
//     return Future.value(true);
//   });
// }
//
// Future<void> main() async {
//
//    WidgetsFlutterBinding.ensureInitialized();
//
//   await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//
//   runApp(const MaterialApp(
//     home: MyApp(),
//   ));
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   final Future<SharedPreferences>_pref = SharedPreferences.getInstance();
//   late Future<int>_counter;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _counter=_pref.then((SharedPreferences preferences) {
//       return preferences.getInt("counter")??0;
//     });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           FutureBuilder(future: _counter,builder: (context, snapshot) {
//             switch(snapshot.connectionState){
//               case ConnectionState.waiting:
//               return const CircularProgressIndicator();
//               default:
//                 if(snapshot.hasError){
//                   return Text("Error ${snapshot.error} ");
//                 }else{
//                   return Text("Button tapped ${snapshot.data} times ${snapshot.data==1?"":"s"}.\n\n "
//                       "This should lpersist acroos restarts");
//                 }
//             }
//           },),
//
//           ElevatedButton(onPressed: ()async{
//             await Workmanager().registerPeriodicTask("1", "fetchBackground", constraints: Constraints(networkType: NetworkType.connected), frequency: Duration(seconds: 15));
//           }, child: Text("Click"))
//
//         ],
//       ),
//     );
//   }
// }






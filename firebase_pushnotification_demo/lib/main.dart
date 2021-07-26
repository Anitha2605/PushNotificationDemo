import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';


// Link that i foolowed for push notifications:
// https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/

void main() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

  runApp(MyApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  showSimpleNotification(
          Text(message.notification!.title!),
          //leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(message.notification!.body!),
          background: Colors.cyan.shade700,
          duration: Duration(seconds: 3),
        );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FirebaseMessaging _messaging;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
    void initState() { 
    super.initState();
    registerNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showSimpleNotification(
          Text(event.notification!.title!),
          //leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(event.notification!.body!),
          background: Colors.cyan.shade700,
          duration: Duration(seconds: 3),
        );

    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    }

    void registerNotification() async {
  // 1. Initialize the Firebase app
  await Firebase.initializeApp();

  // 2. Instantiate Firebase Messaging
  _messaging = FirebaseMessaging.instance;


  _messaging.getToken().then((value){
        print("FCM Token : $value");
    });



  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  } else {
    print('User declined or has not accepted permission');
  }
}



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
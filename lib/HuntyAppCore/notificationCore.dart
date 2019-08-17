import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_reminder/AppUI/main.dart';
import 'dart:async';
import 'dart:typed_data';

var notificationPlugin = new FlutterLocalNotificationsPlugin();

class NotificationCore {
  BuildContext context;
  var initSettingsAndroid;
  var initSettingsIOS;
  var initializationSettings;

  NotificationCore(this.context);

  init() {
    initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    initSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings =
        new InitializationSettings(initSettingsAndroid, initSettingsIOS);
    notificationPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
  }

  displayNotifications(
      String periodInformation, String homeworkInformation) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'lingfeishengtian_homework_reminder_id_913249986',
        'Homework Remind',
        'The notification channel for Homework Reminder.',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: homeworkInformation);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationPlugin.show(
        0, periodInformation, homeworkInformation, platformChannelSpecifics,
        payload: homeworkInformation);
  }

  displayDailyNotification(String periodInformation, String homeworkInformation, Time timeparam) async{
    var time = timeparam;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'lingfeishengtian_homework_reminder_id_913249987',
        'Homework Remind Everyday',
        'To remind the user every day!',
    vibrationPattern: vibrationPattern);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationPlugin.showDailyAtTime(
        0,
        periodInformation,
        homeworkInformation,
        time,
        platformChannelSpecifics);
  }
}

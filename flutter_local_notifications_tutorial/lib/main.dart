import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_tutorial/notification_controller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech4Kidney',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 180),
              const Text(
                'Please complete your survey!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => _launchUrl('https://forms.gle/CU7Pxo7rAwTndDC27'),
                child: const SizedBox(
                  width: 150,
                  child: Center(
                    child: Text('Survey Link'))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _launchUrl('https://forms.gle/CU7Pxo7rAwTndDC27'),
                child: const SizedBox(
                  width: 150,
                  child: Center(
                    child: Text('Sleep Survey Link'))),
              ),
              const Spacer(),
              const Text(
                'Thank you! 🙏',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: "basic_channel",
                  title: "Welcome to Sleep Survey App",
                  body: "Please fill out the following survey"),
            );
          },
          child: const Icon(
            Icons.notification_add,
          ),
        ),
      ),
    );
  }

  void _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}

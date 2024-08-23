import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:KidneyCareWear/notification_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isAllowedToSendNotification =
    await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'daily_notification_channel',
        channelName: 'Daily Survey Notifications',
        channelDescription: 'Notification channel for daily survey reminders',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  runApp(const MyApp());

  // Send a notification as soon as the app opens
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'daily_notification_channel',
      title: 'Welcome to KidneyCareWear',
      body: 'Thank you for opening the app!',
      notificationLayout: NotificationLayout.Default,
      icon: 'resource://drawable/black_kidney',
    ),
  );
}

void scheduleDailyNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'daily_notification_channel',
      title: 'KidneyCareWear',
      body: 'Please take your daily survey!',
      notificationLayout: NotificationLayout.Default,
      icon: 'resource://drawable/black_kidney',
    ),
    schedule: NotificationCalendar(
      hour: 9,
      minute: 0,
      second: 0,
      millisecond: 0,
      repeats: true,
      timeZone: 'America/New_York',
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);

    return Scaffold(
      backgroundColor: const Color(0xFFF6ECED),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 35, color: Color.fromARGB(255, 255, 159, 152), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/kidney_image.png',
              width: 0.7*screenWidth,
              height: 0.7*screenWidth,
            ),
            const Text(
              'KidneyCareWear',
              style: TextStyle(fontSize: 35, color: Color.fromARGB(255, 255, 159, 152), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SurveyPage()),
                );
              },
                style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 60), // Set the minimum width and height for the button
              ),
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 24),
                ),
            ),
            const Spacer(),
            const Text(
              'Thank you for participating!',
              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 112, 112, 112), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Link to consent form',
              style: TextStyle(fontSize: 15, color: Colors.blue, decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
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
        colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 255, 159, 152)),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
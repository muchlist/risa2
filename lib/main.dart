import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/services/pdf_service.dart';

import 'src/api/services/auth_service.dart';
import 'src/api/services/cctv_service.dart';
import 'src/api/services/check_service.dart';
import 'src/api/services/checkp_service.dart';
import 'src/api/services/computer_service.dart';
import 'src/api/services/general_service.dart';
import 'src/api/services/history_service.dart';
import 'src/api/services/improve_service.dart';
import 'src/api/services/other_service.dart';
import 'src/api/services/speed_service.dart';
import 'src/api/services/stock_service.dart';
import 'src/config/pallatte.dart';
import 'src/globals.dart';
import 'src/providers/auth.dart';
import 'src/providers/cctvs.dart';
import 'src/providers/checks.dart';
import 'src/providers/checks_master.dart';
import 'src/providers/computers.dart';
import 'src/providers/dashboard.dart';
import 'src/providers/generals.dart';
import 'src/providers/histories.dart';
import 'src/providers/improves.dart';
import 'src/providers/others.dart';
import 'src/providers/stock.dart';
import 'src/router/routes.dart';
import 'src/screens/landing/landing.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init SharedPrefs
  await App.init();
  // init firebase
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'risa2', // id
      'risa notification', // title
      'channel untuk menampilkan notif risa', // description
      importance: Importance.high,
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
  }

  // add font licensi
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Set notification bar tot transfarent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const String _title = 'RISA';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final generalService = GeneralService();
  final historyService = HistoryService();
  final checkService = CheckService();
  final checkMasterService = CheckpService();
  final authService = AuthService();
  final improveService = ImproveService();
  final stockService = StockService();
  final cctvService = CctvService();
  final computerService = ComputerService();
  final otherService = OtherService();
  final speedService = SpeedService();
  final pdfService = PdfService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(authService)),
        ChangeNotifierProvider(
            create: (context) => HistoryProvider(historyService)),
        ChangeNotifierProvider(
            create: (context) => ImproveProvider(improveService)),
        ChangeNotifierProvider(
            create: (context) => GeneralProvider(generalService)),
        ChangeNotifierProvider(
            create: (context) => CheckProvider(checkService)),
        ChangeNotifierProvider(
            create: (context) => CheckMasterProvider(checkMasterService)),
        ChangeNotifierProvider(
            create: (context) => StockProvider(stockService)),
        ChangeNotifierProvider(create: (context) => CctvProvider(cctvService)),
        ChangeNotifierProvider(
            create: (context) => ComputerProvider(computerService)),
        ChangeNotifierProvider(
            create: (context) => OtherProvider(otherService)),
        ChangeNotifierProvider(
            create: (context) => DashboardProvider(speedService, pdfService)),
      ],
      child: MaterialApp(
        title: MyApp._title,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Pallete.background),
            scaffoldBackgroundColor: Pallete.background,
            primaryColor: Colors.grey,
            accentColor: Pallete.green,
            primarySwatch: Colors.green,
            iconTheme: const IconThemeData(color: Colors.black),
            fontFamily: GoogleFonts.montserrat().fontFamily,
            textTheme: GoogleFonts.montserratTextTheme()),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

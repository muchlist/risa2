import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'src/api/services/altai_maint_service.dart';
import 'src/api/services/altai_virtual_service.dart';
import 'src/api/services/auth_service.dart';
import 'src/api/services/cctv_maint_service.dart';
import 'src/api/services/cctv_service.dart';
import 'src/api/services/check_service.dart';
import 'src/api/services/checkp_service.dart';
import 'src/api/services/computer_service.dart';
import 'src/api/services/config_check_service.dart';
import 'src/api/services/general_service.dart';
import 'src/api/services/history_service.dart';
import 'src/api/services/improve_service.dart';
import 'src/api/services/other_service.dart';
import 'src/api/services/pdf_service.dart';
import 'src/api/services/speed_service.dart';
import 'src/api/services/stock_service.dart';
import 'src/api/services/vendor_service.dart';
import 'src/config/pallatte.dart';
import 'src/globals.dart';
import 'src/providers/altai_maintenance.dart';
import 'src/providers/altai_virtual.dart';
import 'src/providers/auth.dart';
import 'src/providers/cctv_maintenance.dart';
import 'src/providers/cctvs.dart';
import 'src/providers/checks.dart';
import 'src/providers/checks_master.dart';
import 'src/providers/computers.dart';
import 'src/providers/config_check.dart';
import 'src/providers/dashboard.dart';
import 'src/providers/generals.dart';
import 'src/providers/histories.dart';
import 'src/providers/improves.dart';
import 'src/providers/others.dart';
import 'src/providers/stock.dart';
import 'src/providers/vendor_check.dart';
import 'src/router/routes.dart';
import 'src/screens/landing/landing.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
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
    final String license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });

  // Set notification bar tot transfarent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));

  // override http for android less than 7.1.1
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    final int? release =
        int.tryParse(androidInfo.version.release?.split(".")[0] ?? "");
    if (release != null && release <= 7) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const String _title = 'RISA';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GeneralService generalService = const GeneralService();
  final HistoryService historyService = const HistoryService();
  final CheckService checkService = const CheckService();
  final VendorCheckService vendorCheckService = const VendorCheckService();
  final AltaiVirtualService altaiVirtualService = const AltaiVirtualService();
  final CctvMaintService cctvMaintService = const CctvMaintService();
  final AltaiMaintService altaiMaintService = const AltaiMaintService();
  final CheckpService checkMasterService = const CheckpService();
  final AuthService authService = const AuthService();
  final ImproveService improveService = const ImproveService();
  final StockService stockService = const StockService();
  final CctvService cctvService = const CctvService();
  final ComputerService computerService = const ComputerService();
  final OtherService otherService = const OtherService();
  final SpeedService speedService = const SpeedService();
  final PdfService pdfService = const PdfService();
  final ConfigCheckService configCheckService = const ConfigCheckService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      fontFamily: GoogleFonts.montserrat().fontFamily,
      primarySwatch: Colors.green,
    );

    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<AuthProvider>(
            create: (BuildContext context) => AuthProvider(authService)),
        ChangeNotifierProvider<HistoryProvider>(
            create: (BuildContext context) => HistoryProvider(historyService)),
        ChangeNotifierProvider<ImproveProvider>(
            create: (BuildContext context) => ImproveProvider(improveService)),
        ChangeNotifierProvider<GeneralProvider>(
            create: (BuildContext context) => GeneralProvider(generalService)),
        ChangeNotifierProvider<CheckProvider>(
            create: (BuildContext context) => CheckProvider(checkService)),
        ChangeNotifierProvider<VendorCheckProvider>(
            create: (BuildContext context) =>
                VendorCheckProvider(vendorCheckService)),
        ChangeNotifierProvider<AltaiVirtualProvider>(
            create: (BuildContext context) =>
                AltaiVirtualProvider(altaiVirtualService)),
        ChangeNotifierProvider<CheckMasterProvider>(
            create: (BuildContext context) =>
                CheckMasterProvider(checkMasterService)),
        ChangeNotifierProvider<StockProvider>(
            create: (BuildContext context) => StockProvider(stockService)),
        ChangeNotifierProvider<CctvProvider>(
            create: (BuildContext context) => CctvProvider(cctvService)),
        ChangeNotifierProvider<ComputerProvider>(
            create: (BuildContext context) =>
                ComputerProvider(computerService)),
        ChangeNotifierProvider<OtherProvider>(
            create: (BuildContext context) => OtherProvider(otherService)),
        ChangeNotifierProvider<CctvMaintProvider>(
            create: (BuildContext context) =>
                CctvMaintProvider(cctvMaintService)),
        ChangeNotifierProvider<AltaiMaintProvider>(
            create: (BuildContext context) =>
                AltaiMaintProvider(altaiMaintService)),
        ChangeNotifierProvider<DashboardProvider>(
            create: (BuildContext context) =>
                DashboardProvider(speedService, pdfService)),
        ChangeNotifierProvider<ConfigCheckProvider>(
            create: (BuildContext context) =>
                ConfigCheckProvider(configCheckService)),
      ],
      child: MaterialApp(
        title: MyApp._title,
        theme: theme.copyWith(
          appBarTheme: theme.appBarTheme.copyWith(
              backgroundColor: Pallete.background,
              titleTextStyle: theme.textTheme.subtitle1,
              toolbarTextStyle: theme.textTheme.subtitle1,
              iconTheme: theme.iconTheme),
          scaffoldBackgroundColor: Pallete.background,
          primaryColor: Colors.grey,
          colorScheme: theme.colorScheme
              .copyWith(primary: Colors.grey, secondary: Pallete.green),
          iconTheme: const IconThemeData(color: Colors.black),
          textTheme: GoogleFonts.montserratTextTheme(),
          primaryTextTheme: GoogleFonts.montserratTextTheme(),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

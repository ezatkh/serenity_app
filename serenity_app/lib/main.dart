import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'features/cases/cases_viewmodel/cases_viewmodel.dart';
import 'features/dashboard/dashboard_viewmodel/dashboard_viewmodel.dart';
import 'features/dashboard/tabs/profile/profile_viewmodel/profile_viewmodel.dart';
import 'features/splash/splash_ui/splash_ui.dart';
import 'core/services/local/LocalizationService.dart';
import 'core/services/local/firebase_api.dart';
import 'globalErrorListener.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  LocalizationService localizeService = LocalizationService();
  bool isJailbroken = false;
  bool developerMode = false;
  try {
    // Check for jailbreak status
    // isJailbroken = await FlutterJailbreakDetection.jailbroken;
    // developerMode = await FlutterJailbreakDetection.developerMode;
    // print("developer mode :${developerMode} : isJailbroken :${isJailbroken}");
  } on PlatformException {
    isJailbroken = true;
    developerMode = true;
  } catch (e) {
    print("Error localization Jailbroken: $e");
    // Handle initialization error as needed
  }

  if (isJailbroken) {
    runApp(MyApp(isJailbroken: true));
  } else {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,

      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    await Firebase.initializeApp();
    await FirebaseApi().initNotifications();
    try {
      await localizeService.initLocalization();
    } catch (e) {
      print("Error initializing localization: $e");
    }
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LocalizationService()),
          ChangeNotifierProvider(create: (context) => CasesViewModel()),
          ChangeNotifierProvider(create: (context) => DashboardViewModel()),
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ],
        child: const MyApp(isJailbroken: false),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  final bool isJailbroken;

  const MyApp({super.key, required this.isJailbroken});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      fontFamily: 'Inter',
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.light().copyWith(
        primary: AppColors.primaryColor,
        onPrimary: AppColors.primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: AppColors.primaryTextColor), // Use AppColors
      ),
    );

    if (isJailbroken) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'This application cannot be run on jailbroken devices.',
              style: TextStyle(color: AppColors.errorColor, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Consumer<LocalizationService>(builder: (context, localizeService, _) {
      return OKToast(
        child: GlobalErrorListener(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Serenity",
            theme: theme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('pt', 'PT'),
            ],
            locale: Locale(localizeService.selectedLanguageCode),
            home: SplashScreen(),
            builder: (context, child) {
              return Directionality(
                textDirection:  TextDirection.ltr,
                child: child!,
              );
            },
          ),
        ),
      );
    });
  }
}


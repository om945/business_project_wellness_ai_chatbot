import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wellnest_chatbot/models/storage_service.dart'; // This path is correct based on your structure
import 'package:wellnest_chatbot/pages/chat_screen.dart';
import 'package:wellnest_chatbot/pages/onboarding_screen.dart';
import 'package:wellnest_chatbot/provider/provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final storageService = StorageService();
  final bool onboardingComplete = await storageService.isOnboardingComplete();

  runApp(MyApp(onboardingComplete: onboardingComplete));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Uiprovider()..init(),
      child: Consumer<Uiprovider>(
        builder: (context, Uiprovider notifier, child) {
          return ScreenUtilInit(
            designSize: const Size(353, 745),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: true,
              title:
                  'WELLNEX AI: SMART LIFESTYLE AND NUTRITION ADVISORY SYSTEM',
              theme: notifier.lightTheam,
              darkTheme: notifier.darkTheam,
              themeMode: ThemeMode.dark,
              home: onboardingComplete
                  ? const ChatScreen()
                  : const OnboardingScreen(),
            ),
          );
        },
      ),
    );
  }
}

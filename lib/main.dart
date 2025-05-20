import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';
import 'package:mongo_ai/core/event/key/event_key.dart';
import 'package:mongo_ai/core/routing/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // 경로 기반 URL 전략
  // ignore: prefer_const_constructors
  setUrlStrategy(PathUrlStrategy());

  // Remote Database 연결
  // 환경변수 가져오기
  await dotenv.load(fileName: ".env");

  // Imperative push/pushNamed가 URL에 반영되게 허용
  GoRouter.optionURLReflectsImperativeAPIs = true;

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final loader = FontLoader('Pretendard');
  loader.addFont(rootBundle.load('assets/fonts/Pretendard-Bold.ttf'));
  loader.addFont(rootBundle.load('assets/fonts/Pretendard-Medium.ttf'));
  loader.addFont(rootBundle.load('assets/fonts/Pretendard-Regular.ttf'));
  await loader.load();

  runApp(const ProviderScope(child: PracticeApp()));
}

class PracticeApp extends ConsumerWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appEventKey = ref.watch(appEventKeyProvider);
    ref.listen<AppEventState?>(appEventProvider, (
      AppEventState? prevEvent,
      AppEventState? newEvent,
    ) {
      // 만약 이벤트값을 되돌리는 경우라면,
      // 어떠한 이벤트도 발생시키지 않습니다.
      if (newEvent == null) {
        return;
      }
      // 새로운 이벤트를 등록하는 경우라면,
      // 해당 이벤트를 실행시킵니다.
      if (prevEvent == null) {
        switch (newEvent) {
          case ShowSnackBar():
            appEventKey.scaffoldKey.currentState?.showSnackBar(
              SnackBar(content: Text(newEvent.message)),
            );
          case Navigate():
            switch (newEvent.navigateMethod) {
              case NavigationMethod.push:
                appEventKey.navigateKey.currentContext?.push(
                  newEvent.routeName,
                  extra: newEvent.extra,
                );
              case NavigationMethod.go:
                appEventKey.navigateKey.currentContext?.go(
                  newEvent.routeName,
                  extra: newEvent.extra,
                );
            }
          case ShowDialog():
            if (appEventKey.navigateKey.currentContext == null) {
              return;
            }
            showDialog(
              context: appEventKey.navigateKey.currentContext!,
              barrierDismissible: newEvent.barrierDismissible,
              builder: newEvent.builder,
            );
        }
      }
    });
    return MaterialApp.router(
      routerConfig: router,
      scaffoldMessengerKey: appEventKey.scaffoldKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

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
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mongo_ai/core/routing/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // 경로 기반 URL 전략
  // ignore: prefer_const_constructors
  setUrlStrategy(PathUrlStrategy());

  // Remote Database 연결
  // 환경변수 가져오기
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  Supabase.initialize(
    url: 'https://uzohehefpjjptcxisfng.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6b2hlaGVmcGpqcHRjeGlzZm5nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYxNTI3OTcsImV4cCI6MjA2MTcyODc5N30.872S1gvw29Sas_omRxNvuw5-GUGIFV53HqQa_ARlE34',
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );

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

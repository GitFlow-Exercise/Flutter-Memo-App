import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/home/domain/model/home.dart';
import 'package:mongo_ai/home/presentation/home_state.dart';

import 'home_action.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final HomeState state;
  final void Function(HomeAction) onAction;

  const HomeScreen({super.key, required this.state, required this.onAction});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 웹 홈'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.onAction(const HomeAction.refresh()),
          ),
        ],
      ),
      body: widget.state.homeData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                _buildErrorContent(context, error.toString()),
        data: (homeData) => _buildContent(context, homeData),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '에러 발생: $errorMessage',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.onAction(const HomeAction.refresh()),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Home homeData) {
    // 화면 너비에 따라 레이아웃 조정 (반응형)
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        if (isWideScreen) {
          return _buildWideLayout(context, homeData);
        } else {
          return _buildNarrowLayout(context, homeData);
        }
      },
    );
  }

  Widget _buildWideLayout(BuildContext context, Home homeData) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Image.network(homeData.imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeData.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  homeData.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed:
                      () => widget.onAction(const HomeAction.onTapDetail()),
                  child: const Text('자세히 보기'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, Home homeData) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.network(homeData.imageUrl, fit: BoxFit.contain),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  homeData.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  homeData.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed:
                      () => widget.onAction(const HomeAction.onTapDetail()),
                  child: const Text('자세히 보기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mongo AI'),
        ),
        body: Row(
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _onTap(context, 0),
                    child: const Text('Home'),
                  ),
                  ElevatedButton(
                    onPressed: () => _onTap(context, 1),
                    child: const Text('Recent Files'),
                  ),
                  const Divider(height: 32, thickness: 1),
                  // folderProvider 자리
                ],
              ),
            ),
            Expanded(child: widget.navigationShell),
          ],
        )
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(index);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class BaseSelectableView<T> extends ConsumerStatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, List<Widget>) layoutBuilder;
  final void Function(List<T> selectedItems) onSelection;
  final List<T> items;

  const BaseSelectableView({
    super.key,
    required this.itemBuilder,
    required this.layoutBuilder,
    required this.onSelection,
    required this.items,
  });

  @override
  ConsumerState<BaseSelectableView<T>> createState() => _BaseSelectableViewState<T>();
}

class _BaseSelectableViewState<T> extends ConsumerState<BaseSelectableView<T>> {
  Offset? _startGlobal;
  Offset? _currentGlobal;
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    // 모든 아이템에 대해 최초 키 생성
    _keys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant BaseSelectableView<T> old) {
    super.didUpdateWidget(old);

    // 최적화 : workbookList 같은 items 갯수가 변경될 경우에만 키를 재생성
    if (old.items.length != widget.items.length) {
      _keys = List.generate(widget.items.length, (_) => GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final children = List.generate(widget.items.length, (i) {
      return KeyedSubtree(
        key: _keys[i],
        child: widget.itemBuilder(context, widget.items[i]),
      );
    });
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) => isSelectMode ? _handlePanStart(details) : null,
      onPanUpdate: (details) =>  isSelectMode ? _handlePanUpdate(details) : null,
      onPanEnd: (details) =>  isSelectMode ? _handlePanEnd(details) : null,
      child: Stack(
        children: [
          // 최적화 : 그리드를 RepaintBoundary로 감싸서, children이 바뀔 때만 repaint
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: RepaintBoundary(
              child: widget.layoutBuilder(context, children)
            ),
          ),

          if (isSelectMode != false && _startGlobal != null && _currentGlobal != null)
            Positioned.fromRect(
              rect: Rect.fromPoints(
                _toLocal(context, _startGlobal!),
                _toLocal(context, _currentGlobal!),
              ),
              child: Container(
                color: AppColor.primary.withAlpha(50),
              ),
            ),
        ],
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _startGlobal = details.globalPosition;
      _currentGlobal = _startGlobal;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() => _currentGlobal = details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    final selectedRect = Rect.fromPoints(_startGlobal!, _currentGlobal!);
    final selected = <T>[];

    for (var i = 0; i < widget.items.length; i++) {
      final ctx = _keys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final topLeft = box.localToGlobal(Offset.zero);
      final itemRect = topLeft & box.size;

      if (selectedRect.overlaps(itemRect)) {
        selected.add(widget.items[i]);
      }
    }

    widget.onSelection(selected);

    setState(() {
      _startGlobal = null;
      _currentGlobal = null;
    });
  }

  // 로컬 좌표계 (특정 위젯 기준)에서 글로벌 좌표계 (화면 기준)로 변환
  Offset _toLocal(BuildContext context, Offset global) =>
      (context.findRenderObject() as RenderBox).globalToLocal(global);
}

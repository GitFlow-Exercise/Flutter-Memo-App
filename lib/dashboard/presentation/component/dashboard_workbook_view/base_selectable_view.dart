import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class BaseSelectableView<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, List<Widget>) layoutBuilder;
  final void Function(List<T> selectedItems) onSelection;
  final VoidCallback onDragStart;
  final VoidCallback onDragEndEmpty;
  final List<T> items;

  const BaseSelectableView({
    super.key,
    required this.itemBuilder,
    required this.layoutBuilder,
    required this.onSelection,
    required this.onDragStart,
    required this.onDragEndEmpty,
    required this.items,
  });

  @override
  State<BaseSelectableView<T>> createState() => _BaseSelectableViewState<T>();
}

class _BaseSelectableViewState<T> extends State<BaseSelectableView<T>> {
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
    final children = List.generate(widget.items.length, (i) {
      return KeyedSubtree(
        key: _keys[i],
        child: widget.itemBuilder(context, widget.items[i]),
      );
    });
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (d) {
        print('start');
        widget.onDragStart();
        setState(() {
          _startGlobal = d.globalPosition;
          _currentGlobal = _startGlobal;
        });
      },
      onPanUpdate: (d) => setState(() => _currentGlobal = d.globalPosition),
      onPanEnd: (d) {
        print('end');
        final selectedRect = Rect.fromPoints(_startGlobal!, _currentGlobal!);
        final selected = <T>[]; // 선택된 객체 리스트

        for (var i = 0; i < widget.items.length; i++) {
          // 모든 아이템에 대해 키를가지고 각 위젯의 context를 가져옴.
          final context = _keys[i].currentContext;
          if (context == null) continue;

          final box = context.findRenderObject() as RenderBox;
          final topLeft = box.localToGlobal(Offset.zero);
          final itemRect = topLeft & box.size;
          if (selectedRect.overlaps(itemRect)) {
            selected.add(widget.items[i]);
          }
        }

        if (selected.isEmpty) {
          // 선택된게 없으면 선택 모드 끄기
          widget.onDragEndEmpty();
        } else {
          // 선택된 객체 리스트를 콜백 onSelection으로 전달
          widget.onSelection(selected);
        }

        // 드래그 끝났으니 초기화
        setState(() {
          _startGlobal = null;
          _currentGlobal = null;
        });
      },
      child: Stack(
        children: [
          // 최적화 : 그리드를 RepaintBoundary로 감싸서, children이 바뀔 때만 repaint
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: RepaintBoundary(
              child: widget.layoutBuilder(context, children)
            ),
          ),

          if (_startGlobal != null && _currentGlobal != null)
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

  // 로컬 좌표계 (특정 위젯 기준)에서 글로벌 좌표계 (화면 기준)로 변환
  Offset _toLocal(BuildContext context, Offset global) =>
      (context.findRenderObject() as RenderBox).globalToLocal(global);
}

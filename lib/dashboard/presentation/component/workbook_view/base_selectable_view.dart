import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class BaseSelectableView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, List<Widget>) layoutBuilder;
  final void Function(List<T>) onSelection;

  const BaseSelectableView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.layoutBuilder,
    required this.onSelection,
  });

  @override
  State<BaseSelectableView<T>> createState() => _BaseSelectableViewState<T>();
}

class _BaseSelectableViewState<T> extends State<BaseSelectableView<T>> {
  final ValueNotifier<_DragState?> _dragState = ValueNotifier(null);
  late List<GlobalKey> _keys;
  final double _threshold = 100.0;  // 100px 이상 드래그하면 드래그 모드로 진입
  Offset? _downSpot;

  @override
  void initState() {
    super.initState();
    // 최초에 아이템의 개수만큼 GlobalKey를 생성하여 _keys 리스트에 저장함.
    _keys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant BaseSelectableView<T> old) {
    super.didUpdateWidget(old);
    // 아이템의 개수가 변경되었을 때만 키를 새로 생성함.
    if (old.items.length != widget.items.length) {
      _keys = List.generate(widget.items.length, (_) => GlobalKey());
    }
  }

  @override
  void dispose() {
    _dragState.dispose();   // ValueNotifier 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 각 아이템(GridItem 등)을 KeyedSubtree로 감싸서 고유한 키를 부여함.
    final children = List.generate(widget.items.length, (i) {
      return KeyedSubtree(
        key: _keys[i],
        child: widget.itemBuilder(context, widget.items[i]),
      );
    });

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (details) {
        _downSpot = details.localPosition;
      },
      onPanUpdate: (details) {
        final down = _downSpot;
        if (down == null) return;

        // 첫 down 터치 위치와 현재 위치와의 거리 계산
        final current = details.localPosition;
        final dist = (current - down).distance;

        if (_dragState.value == null) {
          // threshold 넘으면 드래그 모드 진입
          if (dist > _threshold) {
            _dragState.value = _DragState(down, current);
          }
        } else {
          // 이미 드래그 모드면 계속 업데이트
          final dragState = _dragState.value!;
          _dragState.value = _DragState(dragState.start, current);
        }
      },
      onPanEnd: (_) {
        // PanEnd는 반드시 DragState가 생성된 후에 호출됨.
        final dragState = _dragState.value;
        if(dragState != null) {
          _computeSelection(context, dragState.start, dragState.current);
        }
        _dragState.value = null;
        _downSpot = null;
      },
      child: Stack(
        children: [
          // RepaintBoundary로 아이템 부분을 리빌드 되지 않도록 함.
          RepaintBoundary(
            child: widget.layoutBuilder(context, children),
          ),

          // 드래그 중일 때만 CustomPaint 오버레이
          ValueListenableBuilder<_DragState?>(
            valueListenable: _dragState,
            builder: (_, dragState, __) {
              // 드래그 상태가 없으면 아무것도 그리지 않음
              if (dragState == null) return const SizedBox.shrink();
              return CustomPaint(
                painter: _SelectionRectPainter(
                  start: dragState.start,
                  end: dragState.current,
                  color: AppColor.primary.withAlpha(50),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ],
      ),
    );
  }

  // 드래그 영역에 포함된 아이템을 선택하는 메서드
  void _computeSelection(BuildContext context, Offset start, Offset current) {
    final dragRect = Rect.fromPoints(start, current);

    // 부모 위젯의 RenderBox가져와서 부모 위젯에 대한 자식 위젯의 상대적인 좌표 계산 (로컬 좌표로 변환)
    final parentBox = context.findRenderObject() as RenderBox;
    final selectedItem = <T>[];

    for (var i = 0; i < widget.items.length; i++) {
      // context. 즉 렌더링이 되었는지 확인하고, 각 item의 RenderBox를 가져옴
      final context = _keys[i].currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox;

      // 각 아이템의 좌측 상단 좌표를 부모 위젯의 RenderBox를 이용하여 부모위젯에 대한 상대적인 좌표로 변환
      final topLeft = parentBox.globalToLocal(box.localToGlobal(Offset.zero));
      final itemRect = topLeft & box.size;      // dart:ui 의 & 연산자는 Offset 과 Size를 이용하여 Rect를 생성함.

      // Rect.overlaps 메서드로 두 사각형이 겹치는지 체크
      if (dragRect.overlaps(itemRect)) selectedItem.add(widget.items[i]);
    }
    widget.onSelection(selectedItem);
  }
}

// ------------------
// 영역 드래그 페인터를 표시하는 부분
class _DragState {
  final Offset start;
  final Offset current;
  _DragState(this.start, this.current);
}

class _SelectionRectPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  _SelectionRectPainter({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(start, end);
    final paint = Paint()..color = color;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _SelectionRectPainter old) {
    return old.start != start || old.end != end || old.color != color;
  }
}
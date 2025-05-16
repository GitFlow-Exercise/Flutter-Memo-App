import 'package:flutter/material.dart';

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
    _keys = List.generate(widget.items.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant BaseSelectableView<T> old) {
    super.didUpdateWidget(old);

    // workbookList 같은 items 갯수가 변경될 경우에만 키를 재생성
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
        widget.onDragStart();
        setState(() {
          _startGlobal = d.globalPosition;
          _currentGlobal = _startGlobal;
        });
      },
      onPanUpdate: (d) => setState(() => _currentGlobal = d.globalPosition),
      onPanCancel: () {
        widget.onDragEndEmpty();
        setState(() {
          _startGlobal = null;
          _currentGlobal = null;
        });
      },
      onPanEnd: (d) {
        final selRect = Rect.fromPoints(_startGlobal!, _currentGlobal!);
        final selected = <T>[];

        for (var i = 0; i < widget.items.length; i++) {
          final ctx = _keys[i].currentContext;
          if (ctx == null) continue;
          final box = ctx.findRenderObject() as RenderBox;
          final topLeft = box.localToGlobal(Offset.zero);
          final itemRect = topLeft & box.size;
          if (selRect.overlaps(itemRect)) {
            selected.add(widget.items[i]);
          }
        }

        if (selected.isEmpty) {
          widget.onDragEndEmpty();
        } else {
          widget.onSelection(selected);
        }

        setState(() {
          _startGlobal = null;
          _currentGlobal = null;
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: widget.layoutBuilder(context, children),
          ),
          if (_startGlobal != null && _currentGlobal != null)
            Positioned.fromRect(
              rect: Rect.fromPoints(
                _toLocal(context, _startGlobal!),
                _toLocal(context, _currentGlobal!),
              ),
              child: Container(
                color: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }

  Offset _toLocal(BuildContext ctx, Offset global) =>
      (ctx.findRenderObject() as RenderBox).globalToLocal(global);
}

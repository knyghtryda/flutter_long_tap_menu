import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:menu/src/helper/ui_helper.dart';

import 'enums.dart';

part 'decoration.dart';
part 'menu_item.dart';
part 'menu_bar.dart';

class Menu extends StatefulWidget {
  final Widget child;
  final MenuBar menuBar;
  final bool menuOverTap;
  final MenuAlignment menuAlignmentOnChild;
  final MenuPosition position;
  final Offset offset;
  final TapType tapType;

  Menu({
    Key key,
    this.child,
    this.menuBar,
    this.menuOverTap = false,
    this.menuAlignmentOnChild = MenuAlignment.topCenter,
    this.position = MenuPosition.outside,
    this.offset = Offset.zero,
    this.tapType = TapType.tap,
  }) : super(key: key);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  final GlobalKey key = GlobalKey();
  OverlayEntry itemEntry;
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: widget.tapType == TapType.tap && !widget.menuOverTap
          ? buildMenu
          : null,
      onDoubleTap: widget.tapType == TapType.doubleTap ? buildMenu : null,
      onSecondaryTap:
          widget.tapType == TapType.secondaryTap && !widget.menuOverTap
              ? buildMenu
              : null,
      onLongPress: widget.tapType == TapType.longPress ? buildMenu : null,
      onTapUp: widget.tapType == TapType.tap && widget.menuOverTap
          ? (details) {
              buildMenu(tapOffset: details.globalPosition);
            }
          : null,
      onSecondaryTapUp:
          widget.tapType == TapType.secondaryTap && widget.menuOverTap
              ? (details) {
                  buildMenu(tapOffset: details.globalPosition);
                }
              : null,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  MenuAlignment childAlignmentOnMenu(MenuAlignment alignment) {
    switch (alignment) {
      case MenuAlignment.topLeft:
        return MenuAlignment.bottomRight;
        break;
      case MenuAlignment.topCenter:
        return MenuAlignment.bottomCenter;
        break;
      case MenuAlignment.topRight:
        return MenuAlignment.bottomLeft;
        break;
      case MenuAlignment.centerLeft:
        return MenuAlignment.centerRight;
        break;
      case MenuAlignment.center:
        return MenuAlignment.center;
        break;
      case MenuAlignment.centerRight:
        return MenuAlignment.centerLeft;
        break;
      case MenuAlignment.bottomLeft:
        return MenuAlignment.topRight;
        break;
      case MenuAlignment.bottomCenter:
        return MenuAlignment.topCenter;
        break;
      case MenuAlignment.bottomRight:
        return MenuAlignment.topLeft;
        break;
      default:
        return MenuAlignment.bottomCenter;
    }
  }

  void buildMenu({Offset tapOffset}) {
    final size = MediaQuery.of(context).size;
    MenuAlignment _childAlignmentOnMenu;
    Offset globalOffset;
    if (tapOffset != null) {
      globalOffset = tapOffset;
      _childAlignmentOnMenu = MenuAlignment.center;
    } else {
      final rect = UIHelper.findGlobalRect(key,
          childAlignBy: widget.menuAlignmentOnChild);
      globalOffset = Offset(rect.left, rect.top);
      _childAlignmentOnMenu = (widget.position == MenuPosition.inside
          ? widget.menuAlignmentOnChild
          : childAlignmentOnMenu(widget.menuAlignmentOnChild));
    }
    itemEntry = OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          dismiss();
        },
        child: _Menu(
          menuBar: widget.menuBar ?? MenuBar(),
          globalOffset: globalOffset,
          menuOffset: widget.offset,
          alignment: _childAlignmentOnMenu,
          dismiss: dismiss,
        ),
      ),
    );

    Overlay.of(context).insert(itemEntry);
  }

  void dismiss() {
    itemEntry.remove();
    itemEntry = null;
  }
}

class _Menu extends StatefulWidget {
  final Offset globalOffset;
  final Offset menuOffset;
  final MenuBar menuBar;
  final MenuAlignment alignment;
  final Function dismiss;

  const _Menu({
    Key key,
    this.globalOffset,
    this.dismiss,
    this.alignment,
    this.menuOffset,
    this.menuBar,
  }) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<_Menu> with AfterLayoutMixin<_Menu> {
  Offset _offset = Offset.zero;
  final GlobalKey menuKey = GlobalKey();
  bool showMenu = false;
  Size _size = Size(0, 0);

  @override
  void initState() {
    _offset = widget.globalOffset - widget.menuOffset;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox renderObject = menuKey.currentContext?.findRenderObject();
    _size = renderObject.size;
    var newOffset;
    switch (widget.alignment) {
      case MenuAlignment.topLeft:
        newOffset = _size.topLeft(Offset.zero);
        break;
      case MenuAlignment.topCenter:
        newOffset = _size.topCenter(Offset.zero);
        break;
      case MenuAlignment.topRight:
        newOffset = _size.topRight(Offset.zero);
        break;
      case MenuAlignment.centerLeft:
        newOffset = _size.centerLeft(Offset.zero);
        break;
      case MenuAlignment.center:
        newOffset = _size.center(Offset.zero);
        break;
      case MenuAlignment.centerRight:
        newOffset = _size.centerRight(Offset.zero);
        break;
      case MenuAlignment.bottomLeft:
        newOffset = _size.bottomLeft(Offset.zero);
        break;
      case MenuAlignment.bottomCenter:
        newOffset = _size.bottomCenter(Offset.zero);
        break;
      case MenuAlignment.bottomRight:
        newOffset = _size.bottomRight(Offset.zero);
        break;
      default:
        newOffset = Offset.zero;
    }
    setState(() {
      _offset -= newOffset;
      showMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Opacity(
      opacity: showMenu ? 1.0 : 0,
      child: Padding(
        padding: EdgeInsets.only(
            left: _offset.dx.clamp(0, size.width - _size.width).toDouble(),
            top: _offset.dy.clamp(0, size.height - _size.height).toDouble()),
        child: FittedBox(
          fit: BoxFit.none,
          alignment: Alignment.topLeft,
          child: _MenuBar(
            menuKey: menuKey,
            menuBar: widget.menuBar,
            dismiss: widget.dismiss,
          ),
        ),
      ),
    );
  }
}

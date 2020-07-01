import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:menu/src/helper/ui_helper.dart';
import 'package:menu/src/menu/tap_type.dart';

part './decoration.dart';

typedef Widget ItemBuilder(
  MenuItem item,
  MenuDecoration menuDecoration,
  VoidCallback dismiss, {
  bool isFirst,
  bool isLast,
});

typedef Widget DividerBuilder(BuildContext context, int lastIndex);

enum MenuAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

class Menu extends StatefulWidget {
  final Widget child;
  final List<MenuItem> items;
  final MenuAlignment menuAlignmentOnChild;
  final double menuSpace;
  final double menuShift;
  final MenuDecoration decoration;
  final ItemBuilder itemBuilder;
  final ClickType clickType;
  final DividerBuilder dividerBuilder;

  const Menu({
    Key key,
    this.items,
    this.child,
    this.menuSpace = 5.0,
    this.menuShift = 0,
    this.menuAlignmentOnChild = MenuAlignment.topCenter,
    this.decoration = const MenuDecoration(),
    this.itemBuilder = defaultItemBuilder,
    this.clickType = ClickType.longPress,
    this.dividerBuilder = buildDivider,
  }) : super(key: key);

  @override
  MenuState createState() => MenuState();

  static Widget buildDivider(BuildContext context, int lastIndex) {
    return Container(
      width: 0.5,
      color: Colors.white,
    );
  }
}

class MenuState extends State<Menu> {
  GlobalKey key = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    switch (widget.clickType) {
      case ClickType.longPress:
        return GestureDetector(
          key: key,
          onLongPress: () => defaultShowItem(),
          behavior: HitTestBehavior.opaque,
          child: widget.child,
        );
        break;
      case ClickType.click:
        return GestureDetector(
          key: key,
          onTap: () => defaultShowItem(),
          behavior: HitTestBehavior.opaque,
          child: widget.child,
        );
      case ClickType.doubleClick:
        return GestureDetector(
          key: key,
          onDoubleTap: () => defaultShowItem(),
          behavior: HitTestBehavior.opaque,
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }

  void defaultShowItem() {
    var rect =
        UIHelper.findGlobalRect(key, childAlignBy: widget.menuAlignmentOnChild);
    showItem(rect);
  }

  OverlayEntry itemEntry;
  bool showMenu = false;

  void showItem(Rect rect) {
    var items = widget.items;
    var size = MediaQuery.of(context).size;
    final _childAlignmentOnMenu =
        childAlignmentOnMenu(widget.menuAlignmentOnChild);
    Widget menuWidget = _MenuWidget(
      offsetRect: rect,
      size: size,
      items: items,
      alignment: _childAlignmentOnMenu,
      decoration: widget.decoration,
      dismissBackground: dismissBackground,
      dividerBuilder: widget.dividerBuilder,
      itemBuilder: widget.itemBuilder,
    );

    itemEntry = OverlayEntry(
        builder: (BuildContext context) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                dismissBackground();
              },
              child: menuWidget,
            ));

    Overlay.of(context).insert(itemEntry);
  }

  void dismissBackground() {
    itemEntry.remove();
    itemEntry = null;
  }
}

class _MenuWidget extends StatefulWidget {
  final Size size;
  final Rect offsetRect;
  final MenuAlignment alignment;
  final List<MenuItem> items;
  final MenuDecoration decoration;
  final ItemBuilder itemBuilder;
  final DividerBuilder dividerBuilder;
  final Function dismissBackground;

  const _MenuWidget(
      {Key key,
      this.size,
      this.offsetRect,
      this.items,
      this.decoration,
      this.itemBuilder,
      this.dividerBuilder,
      this.dismissBackground,
      this.alignment})
      : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<_MenuWidget>
    with AfterLayoutMixin<_MenuWidget> {
  Offset offset = Offset.zero;
  GlobalKey menuKey = GlobalKey();
  bool showMenu = false;

  @override
  void initState() {
    offset = Offset(widget.offsetRect.left, widget.offsetRect.top);
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox renderObject = menuKey.currentContext?.findRenderObject();
    Size _size = renderObject.size;
    print(_size);
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
      offset -= newOffset;
      showMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.offsetRect);
    print(offset);
    return Opacity(
      opacity: showMenu ? 1.0 : 0,
      child: Padding(
        padding: EdgeInsets.only(left: offset.dx, top: offset.dy),
        child: FittedBox(
          fit: BoxFit.none,
          alignment: Alignment.topLeft,
          child: Container(
            height: 36,
            alignment: Alignment.topLeft,
            // color: Colors.green,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              key: menuKey,
              scrollDirection: Axis.horizontal,
              children: widget.items.map((item) {
                var index = widget.items.indexOf(item);
                var itemWidget = widget.itemBuilder(
                  item,
                  widget.decoration,
                  widget.dismissBackground,
                  isFirst: index == 0,
                  isLast: index == widget.items.length - 1,
                );
                return Row(
                  children: <Widget>[
                    itemWidget,
                    if (index != widget.items.length - 1)
                      widget.dividerBuilder(context, index),
                  ],
                );
              }).toList(),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final Function onTap;

  const MenuItem(this.text, this.onTap);
}

Widget defaultItemBuilder(
  MenuItem item,
  MenuDecoration menuDecoration,
  VoidCallback dismiss, {
  bool isFirst,
  bool isLast,
}) {
  final BoxConstraints constraints =
      menuDecoration.constraints ?? const BoxConstraints();

  final EdgeInsetsGeometry itemPadding = menuDecoration.padding ??
      const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      );

  var r = menuDecoration.radius;
  var radius = BorderRadius.horizontal(
    left: isFirst ? Radius.circular(r) : Radius.zero,
    right: isLast ? Radius.circular(r) : Radius.zero,
  );

  return ClipRRect(
    borderRadius: radius,
    child: Material(
      color: menuDecoration.color,
      child: InkWell(
        splashColor: menuDecoration.splashColor,
        // color: menuDecoration.color,
        child: Container(
          padding: itemPadding,
          constraints: constraints,
          alignment: Alignment.center,
          child: Text(
            item.text,
            style: menuDecoration.textStyle,
          ),
        ),
        onTap: () {
          item.onTap();
          dismiss();
        },
      ),
    ),
  );
}

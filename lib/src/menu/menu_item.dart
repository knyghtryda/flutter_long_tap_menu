part of 'menu.dart';

class MenuItem {
  final Widget child;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsets padding;
  final Function onTap;

  MenuItem({
    this.onTap,
    this.child,
    this.backgroundColor = Colors.grey,
    Color splashColor,
    this.padding = const EdgeInsets.all(10),
  }) : this.splashColor = splashColor ?? Colors.grey[100];
}

class _MenuItem extends StatefulWidget {
  final MenuItem menuItem;
  final Function dismiss;

  const _MenuItem({
    Key key,
    this.dismiss,
    this.menuItem,
  }) : super(key: key);
  @override
  __MenuItemState createState() => __MenuItemState();
}

class __MenuItemState extends State<_MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.menuItem.backgroundColor,
      child: InkWell(
        splashColor: widget.menuItem.splashColor,
        child: Container(
          padding: widget.menuItem.padding,
          alignment: Alignment.center,
          child: widget.menuItem.child,
        ),
        onTap: () {
          if(widget.menuItem.onTap != null) widget.menuItem.onTap();
          widget.dismiss();
        },
      ),
    );
  }
}
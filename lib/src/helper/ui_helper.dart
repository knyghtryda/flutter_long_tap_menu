import 'package:flutter/material.dart';

import '../menu/enums.dart';

class UIHelper {
  UIHelper._();

  static Rect findGlobalRect(GlobalKey key,
      {childAlignBy = MenuAlignment.topLeft}) {
    RenderBox renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) {
      return null;
    }

    var globalOffset = renderObject?.localToGlobal(Offset.zero);

    if (globalOffset == null) {
      return null;
    }

    var bounds = renderObject.paintBounds;
    Offset alignmentOffset;

    switch (childAlignBy) {
      case MenuAlignment.topLeft:
        alignmentOffset = bounds.topLeft;
        break;
      case MenuAlignment.topCenter:
        alignmentOffset = bounds.topCenter;
        break;
      case MenuAlignment.topRight:
        alignmentOffset = bounds.topRight;
        break;
      case MenuAlignment.centerLeft:
        alignmentOffset = bounds.centerLeft;
        break;
      case MenuAlignment.center:
        alignmentOffset = bounds.center;
        break;
      case MenuAlignment.centerRight:
        alignmentOffset = bounds.centerRight;
        break;
      case MenuAlignment.bottomLeft:
        alignmentOffset = bounds.bottomLeft;
        break;
      case MenuAlignment.bottomCenter:
        alignmentOffset = bounds.bottomCenter;
        break;
      case MenuAlignment.bottomRight:
        alignmentOffset = bounds.bottomRight;
        break;
      default:
        alignmentOffset = Offset.zero;
    }

    var finalOffset = globalOffset + alignmentOffset;
    bounds = bounds.translate(
        finalOffset.dx, finalOffset.dy);
    return bounds;
  }
}

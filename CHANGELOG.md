## 0.1.5
Changed how the menu is drawn so that it is positioned on the outside of whatever you're clicking on.  This is bound to the `menuAlignmentOnChild` parameter which takes a `MenuAlignment` enum.  This tells the menu in which area of the child object you'd like to render the menu (`MenuAlignment.top` would center the menu above the child while `MenuAlignment.bottomLeft` would place it in the bottom left corner).  Note that the menu will never overlap the child (except for `MenuAlignment.center`, for obvious reasons).  The menu's position can then be fine-tuned with the `offset` parameter, which is just a fixed offset in screen coordinates of how you want the menu to be shifted.  If you want your menu to be up by 10 units then you just pass `Offset(0, 10)` into the `offset` parameter.

## 0.1.4

add divider builder

## 0.1.3

add click type params

## 0.1.2

update readme

add two decoration params

## 0.1.1

If it goes beyond the screen, you can scroll.

## 0.1.0

first version

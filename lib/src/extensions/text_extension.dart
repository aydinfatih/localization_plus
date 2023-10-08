import 'package:flutter/widgets.dart';
import 'package:localization_plus/src/helpers.dart' as helpers;

extension TextExtension on Text {
  Text trans({Map<String, String>? arguments}) => Text(
        helpers.trans(
          data ?? '',
          arguments: arguments,
        ),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        selectionColor: selectionColor,
        textHeightBehavior: textHeightBehavior,
      );

  Text transChoice(num number, {Map<String, String>? arguments}) => Text(
        helpers.transChoice(
          data ?? '',
          number,
          arguments: arguments,
        ),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        selectionColor: selectionColor,
        textHeightBehavior: textHeightBehavior,
      );

  Text plural(num number, {Map<String, String>? arguments}) => Text(
        helpers.plural(
          data ?? '',
          number,
          arguments: arguments,
        ),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        selectionColor: selectionColor,
        textHeightBehavior: textHeightBehavior,
      );
}

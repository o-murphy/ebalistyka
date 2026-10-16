import 'package:material_ui/material_ui.dart';

/// [Text] that draws the arrows ↑ ↓ → ← as Material icons.
///
/// The bundled Roboto has no arrow glyphs, and the only font that did
/// (Noto Sans Symbols) is OFL-licensed, which we don't ship next to the GPL
/// app; the icon font is already bundled and is Apache-2.0. The plain
/// strings stay as they are for places that don't go through Flutter text
/// (e.g. the HTML table export).
class ArrowText extends StatelessWidget {
  const ArrowText(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  static const _icons = {
    '↑': Icons.arrow_upward,
    '↓': Icons.arrow_downward,
    '→': Icons.arrow_forward,
    '←': Icons.arrow_back,
  };

  @override
  Widget build(BuildContext context) {
    if (!text.runes.any((r) => _icons.containsKey(String.fromCharCode(r)))) {
      return Text(text, style: style);
    }
    final effective = DefaultTextStyle.of(context).style.merge(style);
    final size = (effective.fontSize ?? 14) * 1.1;
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          for (final ch in text.split(''))
            if (_icons[ch] case final icon?)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(icon, size: size, color: effective.color),
              )
            else
              TextSpan(text: ch),
        ],
      ),
    );
  }
}

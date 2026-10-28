// The Home reticle messages come from l10n, not from hard-coded English.
import 'package:bclibc/unit.dart';
import 'package:ebalistyka/features/home/home_builders.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<AppLocalizations> load(String code) =>
      AppLocalizations.delegate.load(Locale(code));

  String? zeroOffsetLine(AppLocalizations l10n) => buildZeroOffsetMessageLine(
    zeroOffsetYUnit: Unit.mil,
    zeroOffsetXUnit: Unit.mil,
    zeroOffsetYMil: 0.5,
    zeroOffsetXMil: -0.3,
    l10n: l10n,
  );

  test('zero offset message in English', () async {
    expect(
      zeroOffsetLine(await load('en')),
      'Zero offset: +0.50 MIL vertical / -0.30 MIL horizontal',
    );
  });

  test('zero offset message in Ukrainian has no English words', () async {
    final line = zeroOffsetLine(await load('uk'))!;
    expect(line, startsWith('Зміщення нуля:'));
    expect(line, contains('вертикаль'));
    expect(line, contains('горизонталь'));
    expect(line, isNot(contains('vertical')));
    expect(line, isNot(contains('horizontal')));
  });

  test('custom drag table point count follows the locale', () async {
    final en = await load('en');
    final uk = await load('uk');
    expect(en.nPoints(1), '1 point');
    expect(en.nPoints(5), '5 points');
    expect(uk.nPoints(1), '1 точка');
    expect(uk.nPoints(5), '5 точок');
  });
}

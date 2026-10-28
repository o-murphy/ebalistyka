import 'package:ebalistyka/features/tables/details_table_mv.dart';
import 'package:ebalistyka/features/tables/table_html_exporter.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('DetailsTableData.sections', () {
    test('groups the values under weapon, cartridge, projectile, conditions', () {
      const d = DetailsTableData(weaponName: 'W', bc: '0.4', windDir: '45');
      final sections = d.sections(l10n);

      expect(sections.map((s) => s.title), [
        l10n.weapon,
        l10n.cartridge,
        l10n.projectile,
        l10n.conditions,
      ]);
      expect(sections[0].rows.first, (l10n.weaponName, 'W'));
      expect(sections[2].rows.firstWhere((r) => r.$1 == l10n.bc).$2, '0.4');
      expect(sections[3].rows.last, (l10n.windDirection, '45'));
      expect(sections[1].rows.every((r) => r.$2 == null), isTrue);
    });
  });

  group('HTML details report', () {
    test('skips rows without a value and sections left empty', () {
      const d = DetailsTableData(weaponName: 'W', currentMv: '700');
      final html = TableHtmlExporter.buildDetailsHtml(d, l10n: l10n);

      expect(html, contains('<h2>${l10n.cartridge}</h2>'));
      expect(html, contains('<td class="val">700</td>'));
      expect(html, isNot(contains('<h2>${l10n.projectile}</h2>')));
      expect(html, isNot(contains('<h2>${l10n.conditions}</h2>')));
      expect(html, isNot(contains(l10n.zeroMv)));
    });

    test('always shows the weapon card, even with an empty name', () {
      const d = DetailsTableData(weaponName: '');
      final html = TableHtmlExporter.buildDetailsHtml(d, l10n: l10n);

      expect(html, contains('<h2>${l10n.weapon}</h2>'));
      expect(html, contains('<td class="val"></td>'));
      expect(html, isNot(contains('<h2>${l10n.cartridge}</h2>')));
    });

    test('escapes values', () {
      const d = DetailsTableData(weaponName: 'A<B>&C');
      final html = TableHtmlExporter.buildDetailsHtml(d, l10n: l10n);

      expect(html, contains('A&lt;B&gt;&amp;C'));
      expect(html, isNot(contains('A<B>')));
    });
  });
}

import 'package:ebalistyka/core/providers/shot_context_provider.dart';
import 'package:ebalistyka/features/tables/details_table_mv.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/constants/null_string.dart';
import 'package:ebalistyka/shared/widgets/empty_state.dart';
import 'package:ebalistyka/shared/widgets/list_section_tile.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebalistyka/shared/widgets/dividers.dart';

class DetailsTable extends ConsumerWidget {
  const DetailsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(detailsTableMvProvider);

    if (details == null) {
      final profile = ref.watch(shotContextProvider).value?.profile;
      return EmptyStatePlaceholder(
        type: profile == null
            ? EmptyStateType.noProfile
            : missingProfileDataType(profile),
      );
    }

    return DetailsTableContent(details: details);
  }
}

class DetailsTableContent extends StatelessWidget {
  const DetailsTableContent({required this.details, super.key});

  final DetailsTableData details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (cs, tt) = (theme.colorScheme, theme.textTheme);
    final l10n = AppLocalizations.of(context)!;

    Widget row(String label, String value) => ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(
        value,
        style: tt.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          color: cs.onSurface,
        ),
      ),
    );

    String v(String? s) => s?.isNotEmpty == true ? s! : nullStr;

    final sections = details.sections(l10n);
    final items = <Widget>[
      for (final (i, section) in sections.indexed) ...[
        if (i > 0) const TileDivider(),
        ListSectionTile(section.title),
        for (final (label, value) in section.rows) row(label, v(value)),
      ],
    ];

    return ListView(children: items);
  }
}

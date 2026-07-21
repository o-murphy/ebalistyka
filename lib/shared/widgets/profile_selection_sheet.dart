import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebc_db/ebc_db.dart';
import 'package:flutter/material.dart';

/// Checkbox bottom sheet letting the user pick a subset of [profiles] to
/// import — shared by the Profiles-screen single-profile import flow
/// (`profile_ebcp_actions.dart`) and the Settings/Backup screen's
/// "all profiles"/"everything" import scope (`settings_screen.dart`), both
/// of which need "pick which of these profiles to bring in," just from
/// files that usually carry one profile vs. many.
///
/// Returns the profiles the user left checked (possibly empty — the button
/// reads "Skip" and stays enabled at zero, so the caller can distinguish
/// "confirmed with nothing selected" from a dismissal), or `null` if the
/// sheet was dismissed without confirming (back gesture / tap outside).
Future<List<Profile>?> showProfileSelectionSheet(
  BuildContext context,
  List<Profile> profiles,
) => showModalBottomSheet<List<Profile>>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _ProfileSelectionSheet(profiles: profiles),
);

class _ProfileSelectionSheet extends StatefulWidget {
  const _ProfileSelectionSheet({required this.profiles});
  final List<Profile> profiles;

  @override
  State<_ProfileSelectionSheet> createState() => _ProfileSelectionSheetState();
}

class _ProfileSelectionSheetState extends State<_ProfileSelectionSheet> {
  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.profiles.length, true);
  }

  bool get _allSelected => _checked.every((c) => c);
  bool get _noneSelected => _checked.every((c) => !c);

  void _toggleAll(bool? value) {
    final next = value ?? !_allSelected;
    setState(() {
      for (var i = 0; i < _checked.length; i++) {
        _checked[i] = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedCount = _checked.where((c) => c).length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.selectProfilesToImportTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
        const Divider(height: 17),
        if (widget.profiles.length > 1)
          CheckboxListTile(
            value: _allSelected ? true : (_noneSelected ? false : null),
            tristate: true,
            onChanged: _toggleAll,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(l10n.selectAllAction),
          ),
        if (widget.profiles.length > 1) const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget.profiles.length,
            itemBuilder: (context, i) {
              final profile = widget.profiles[i];
              return CheckboxListTile(
                value: _checked[i],
                onChanged: (v) => setState(() => _checked[i] = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(profile.name),
                subtitle: profile.weapon.name.isNotEmpty
                    ? Text(profile.weapon.name)
                    : null,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop([
                for (var i = 0; i < widget.profiles.length; i++)
                  if (_checked[i]) widget.profiles[i],
              ]),
              child: Text(
                selectedCount > 0
                    ? l10n.importAllProfilesAction(selectedCount)
                    : l10n.skipAction,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

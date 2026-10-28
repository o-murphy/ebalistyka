import 'package:ebalistyka/features/convertors/simple_convertor_vm.dart';
import 'package:ebalistyka/l10n/app_localizations.dart';
import 'package:ebalistyka/shared/widgets/base_screen.dart';
import 'package:ebalistyka/shared/widgets/dividers.dart';
import 'package:ebalistyka/shared/widgets/info_tile.dart';
import 'package:ebalistyka/shared/widgets/list_section_tile.dart';
import 'package:ebalistyka/shared/widgets/unit_constrained_input_with_unit_picker_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Screen of a simple convertor: the input with its unit picker, then the
/// value in the other units. What it shows comes from [provider]'s spec.
class SimpleConvertorScreen extends ConsumerWidget {
  const SimpleConvertorScreen({required this.provider, super.key});

  final NotifierProvider<SimpleConvertorVm, SimpleConvertorUiState> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return BaseScreen(
      title: vm.spec.title(l10n),
      isSubscreen: true,
      body: ListView(
        children: [
          UnitInputWithPicker(
            value: state.rawValue,
            constraints: vm.getConstraintsForUnit(state.inputUnit),
            displayUnit: state.inputUnit,
            onChanged: vm.updateRawValue,
            onUnitChanged: vm.changeInputUnit,
            options: vm.spec.unitOptions,
            hintText: vm.spec.hint(l10n),
          ),
          const SectionDivider(),
          for (final section in state.sections) ...[
            ListSectionTile(section.titleBuilder(l10n)),
            for (final field in section.fields)
              InfoListTile(
                label: field.labelBuilder(l10n),
                value: field.formattedValue,
              ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

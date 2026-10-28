import 'dart:async';
import 'dart:math';
import 'package:bclibc/unit.dart';
import 'package:ebalistyka/core/models/field_constraints.dart' as fc;
import 'package:ebalistyka/shared/helpers/unit_constrained_convertion_helper.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Reusable wheel picker widget
class UnitWheelPickerWidget extends StatefulWidget {
  const UnitWheelPickerWidget({
    super.key,
    required this.constraints,
    required this.initialRawValue,
    required this.displayUnit,
    required this.onChanged,
  });

  final fc.Constraints constraints;
  final double? initialRawValue;
  final Unit displayUnit;
  final ValueChanged<double> onChanged;

  @override
  State<UnitWheelPickerWidget> createState() => _UnitWheelPickerWidgetState();
}

class _UnitWheelPickerWidgetState extends State<UnitWheelPickerWidget> {
  late FixedExtentScrollController _controller;
  late UnitConversionHelper _helper;
  List<double> _displayValues = [];
  late double _currentRawValue;
  int _currentIndex = 0;
  // Set around programmatic _controller.jumpToItem() calls (external raw
  // value sync via didUpdateWidget) so the resulting onSelectedItemChanged
  // doesn't get treated as a genuine user scroll — was declared `final...
  // false` before (dead code, never actually set), so a jump triggered by
  // e.g. the sibling text field being typed into would bounce right back
  // through widget.onChanged and overwrite what was being typed with the
  // nearest wheel step.
  bool _isUpdatingFromWidget = false;

  // Mouse-wheel input, see [_onPointerSignal].
  static const _wheelStepPx = 40.0;
  double _wheelPx = 0;

  @override
  void initState() {
    super.initState();
    _initHelper();
    _currentRawValue = widget.initialRawValue ?? widget.constraints.minRaw;
    _generateDisplayValues();
    _currentIndex = _findClosestIndex(_currentRawValue);
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  void _initHelper() {
    _helper = UnitConversionHelper(
      constraints: widget.constraints,
      displayUnit: widget.displayUnit,
    );
  }

  @override
  void didUpdateWidget(covariant UnitWheelPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsRegenerate = false;
    bool needsValueUpdate = false;

    if (oldWidget.constraints != widget.constraints ||
        oldWidget.displayUnit != widget.displayUnit) {
      _initHelper();
      needsRegenerate = true;
    }

    if (oldWidget.initialRawValue != widget.initialRawValue &&
        widget.initialRawValue != null) {
      _currentRawValue = widget.initialRawValue!;
      needsValueUpdate = true;
    }

    if (needsRegenerate) {
      _generateDisplayValues();
      needsValueUpdate = true;
    }

    if (needsValueUpdate) {
      final newIndex = _findClosestIndex(_currentRawValue);
      if (_currentIndex != newIndex) {
        _currentIndex = newIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients) {
            _isUpdatingFromWidget = true;
            _controller.jumpToItem(_currentIndex);
            _isUpdatingFromWidget = false;
          }
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _generateDisplayValues() {
    final minDisplay = _helper.displayMin;
    final maxDisplay = _helper.displayMax;

    double stepDisplay;
    if (widget.constraints is fc.RulerConstraints) {
      final rc = widget.constraints as fc.RulerConstraints;
      final val1 = _helper.toDisplay(rc.minRaw);
      final val2 = _helper.toDisplay(rc.minRaw + rc.stepRaw);
      stepDisplay = (val2 - val1).abs();
    } else {
      stepDisplay = 1 / pow(10, _helper.accuracy);
    }

    if (stepDisplay <= 0) stepDisplay = 1.0;

    final List<double> values = [];
    double current = minDisplay;
    int safetyGuard = 0;
    while (current <= maxDisplay + (stepDisplay / 2) && safetyGuard < 5000) {
      values.add(current);
      current += stepDisplay;
      safetyGuard++;
    }
    _displayValues = values;
  }

  int _findClosestIndex(double rawValue) {
    if (_displayValues.isEmpty) return 0;
    final displayVal = _helper.toDisplay(rawValue);
    int closest = 0;
    double minDiff = double.maxFinite;
    for (int i = 0; i < _displayValues.length; i++) {
      final diff = (displayVal - _displayValues[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = i;
      }
    }
    return closest;
  }

  void _handleSelectedItemChanged(int index) {
    if (_isUpdatingFromWidget) return;
    if (index < 0 || index >= _displayValues.length) return;

    setState(() {
      _currentIndex = index;
      final displayValue = _displayValues[index];
      _currentRawValue = _helper
          .toRaw(displayValue)
          .clamp(widget.constraints.minRaw, widget.constraints.maxRaw);
    });
    widget.onChanged(_currentRawValue);
    unawaited(HapticFeedback.selectionClick());
  }

  /// One mouse-wheel notch moves the wheel one value. By default the scroll
  /// view moves by the event's pixel delta (100-120 px per notch on most
  /// platforms, ~2.5 items of 44 px), which skipped values. Small deltas
  /// (touchpads, high-resolution wheels) still add up to a step per
  /// [_wheelStepPx].
  ///
  /// Registered from the items, which sit below the scroll view in the hit
  /// test, so this runs before — and instead of — the scroll view's own
  /// handler (the resolver keeps only the first registered callback).
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (e) {
      final dy = (e as PointerScrollEvent).scrollDelta.dy;
      if (dy == 0 || !_controller.hasClients) return;
      if (_wheelPx.sign != dy.sign) _wheelPx = 0;
      _wheelPx += dy;
      if (_wheelPx.abs() < _wheelStepPx) return;
      final direction = _wheelPx.sign.toInt();
      _wheelPx = 0;
      final target = (_currentIndex + direction).clamp(
        0,
        _displayValues.length - 1,
      );
      if (target == _currentIndex) return;
      unawaited(
        _controller.animateToItem(
          target,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (cs, tt) = (theme.colorScheme, theme.textTheme);
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withAlpha(76),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 44,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: _handleSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: _displayValues.length,
              builder: (context, index) {
                final isSelected = _currentIndex == index;
                return Listener(
                  onPointerSignal: _onPointerSignal,
                  child: Center(
                    child: Text(
                      _helper.formatDisplayValue(_displayValues[index]),
                      style: tt.titleLarge?.copyWith(
                        color: isSelected
                            ? cs.primary
                            : cs.onSurface.withAlpha(100),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

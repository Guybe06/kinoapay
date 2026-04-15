import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/application/auth_validator.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_date_utils.dart";

/// Sélecteurs jour / mois / année pour la date de naissance (style champ auth).
class SignupBirthDateField extends StatelessWidget {
  static const BorderRadius fieldRadius = BorderRadius.only(
    topRight: Radius.circular(24),
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );

  final GlobalKey<FormFieldState<void>> formFieldKey;
  final int selectedDay;
  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onYearChanged;

  const SignupBirthDateField({
    super.key,
    required this.formFieldKey,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onDayChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<void>(
      key: formFieldKey,
      validator: (_) => AuthValidator.validateBirthDateParts(
            selectedDay.toString(),
            selectedMonth.toString(),
            selectedYear.toString(),
          ),
      builder: (state) {
        final maxDay = signupDaysInMonth(selectedYear, selectedMonth);
        final dayValues = List.generate(maxDay, (i) => i + 1);
        final years = signupBirthYearOptions();
        final borderColor = state.hasError
            ? AppColors.quinoaRed.withValues(alpha: 0.35)
            : AppColors.quinoaDark.withValues(alpha: 0.12);
        final dividerColor = AppColors.quinoaDark.withValues(alpha: 0.1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.65),
                borderRadius: fieldRadius,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 12),
                    child: Text(
                      AuthStrings.birthDateLabel,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.45),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _dateSegment(
                          value: selectedDay,
                          items: dayValues.map((d) => DropdownMenuItem(value: d, child: Text("$d"))).toList(),
                          onChanged: (v) {
                            onDayChanged(v!);
                            state.didChange(null);
                          },
                        ),
                      ),
                      _verticalDivider(dividerColor),
                      Expanded(
                        flex: 4,
                        child: _dateSegment(
                          value: selectedMonth,
                          items: List.generate(
                            12,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text(signupBirthMonthNamesFr[i], overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          onChanged: (v) {
                            onMonthChanged(v!);
                            state.didChange(null);
                          },
                        ),
                      ),
                      _verticalDivider(dividerColor),
                      Expanded(
                        flex: 3,
                        child: _dateSegment(
                          value: selectedYear,
                          items: years.map((y) => DropdownMenuItem(value: y, child: Text("$y"))).toList(),
                          onChanged: (v) {
                            onYearChanged(v!);
                            state.didChange(null);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 24),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: AppColors.quinoaRed, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _dateSegment({
    required int value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          menuMaxHeight: 320,
          icon: Icon(Icons.expand_more_rounded, size: 18, color: AppColors.quinoaDark.withValues(alpha: 0.35)),
          style: const TextStyle(color: AppColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w600),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _verticalDivider(Color color) {
    return Container(width: 1, height: 28, color: color);
  }
}

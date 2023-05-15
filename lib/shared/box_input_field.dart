import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxInputField extends StatelessWidget {
  final controller;
  final String placeholder;
  final String? errorText;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? traillingTapped;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool password;
  final bool enable;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  BoxInputField(
      {Key? key,
      this.placeholder = '',
      this.leading,
      this.trailing,
      this.traillingTapped,
      this.onChanged,
      this.controller,
      this.password = false,
      this.enable = false,
      this.onTap,
      required this.readOnly,
      this.errorText,
      this.inputFormatters,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(height: 1),
      inputFormatters: [
        ...inputFormatters ?? [],
      ],
      keyboardType: keyboardType,
      obscureText: password,
      decoration: InputDecoration(
        hintText: placeholder,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        filled: true,
        errorText: errorText,
        fillColor: kcVeryLightGreyColor,
        prefixIcon: leading,
        suffixIcon: trailing != null
            ? GestureDetector(
                onTap: traillingTapped,
                child: trailing,
              )
            : null,
        border: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLightGreyColor),
        ),
        errorBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcPrimaryDarkerColor),
        ),
        enabledBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: kcLightGreyColor),
        ),
      ),
    );
  }
}

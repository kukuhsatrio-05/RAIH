import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;

  // Password
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onTogglePassword;

  // Dropdown
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final ValueChanged<String?>? onDropdownChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.isObscure = false,
    this.onTogglePassword,

    // Dropdown
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedValue,
    this.onDropdownChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(bool isFocused) {
    return InputDecoration(
      labelText: widget.label,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: AppColors.blueNormal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      filled: true,
      fillColor: Colors.transparent,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(color: AppColors.blueNormal, width: 2),
      ),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return SizedBox(
      width: 348,
      height: 56,
      child: widget.isDropdown
          ? DropdownButtonFormField<String>(
              focusNode: _focusNode,
              initialValue: widget.selectedValue,
              decoration: _inputDecoration(isFocused),

              items: widget.dropdownItems
                  ?.map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),

              onChanged: widget.onDropdownChanged,

              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isFocused ? AppColors.blueNormal : Colors.grey,
              ),

              borderRadius: BorderRadius.circular(16),
            )
          : TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isPassword && widget.isObscure,

              decoration: _inputDecoration(isFocused).copyWith(
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          widget.isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: isFocused ? AppColors.blueNormal : Colors.grey,
                        ),
                        onPressed: widget.onTogglePassword,
                      )
                    : null,
              ),
            ),
    );
  }
}


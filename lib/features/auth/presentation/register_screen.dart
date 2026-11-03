import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/features/auth/presentation/auth_controller.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. Header Gradient & Ilustrasi
                SizedBox(
                  height: screenHeight * 0.36,
                  child: Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.30,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.blueGradientStart,
                              AppColors.blueGradientEnd,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -30,
                              left: -30,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            SafeArea(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/raih.svg',
                                    height: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.26,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.26 - 65,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/register_illustration.svg',
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Area Form Pendaftaran
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Daftar',
                        style: AppTextStyles.bold24.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anda telah memiliki akun? ',
                            style: AppTextStyles.regular14.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Masuk',
                              style: AppTextStyles.semibold14.copyWith(
                                color: AppColors.blueGradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Field 1: Nama Lengkap
                      _buildTextField(
                        label: 'Nama Lengkap',
                        isFilled: state.fullName.isNotEmpty,
                        onChanged: notifier.setFullName,
                      ),
                      const SizedBox(height: 16),

                      // Field 2: Email
                      _buildTextField(
                        label: 'Email',
                        isFilled: state.email.isNotEmpty,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: notifier.setEmail,
                      ),
                      const SizedBox(height: 16),

                      // Field 3: No Aktif
                      _buildTextField(
                        label: 'No Aktif',
                        isFilled: state.phoneNumber.isNotEmpty,
                        keyboardType: TextInputType.phone,
                        onChanged: notifier.setPhoneNumber,
                      ),
                      const SizedBox(height: 16),

                      // Field 4: Instansi (Autocomplete + Input Bebas)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Autocomplete<String>(
                            initialValue: TextEditingValue(
                              text: state.selectedInstitution ?? '',
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return notifier.faculties.where((
                                    String option,
                                  ) {
                                    return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    );
                                  });
                                },
                            onSelected: (String selection) {
                              notifier.setInstitution(selection);
                            },
                            fieldViewBuilder:
                                (
                                  context,
                                  controller,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    onChanged: notifier.setInstitution,
                                    decoration: InputDecoration(
                                      labelText: 'Fakultas',
                                      labelStyle: TextStyle(
                                        color:
                                            (state.selectedInstitution !=
                                                    null &&
                                                state
                                                    .selectedInstitution!
                                                    .isNotEmpty)
                                            ? AppColors.blueGradientEnd
                                            : Colors.grey.shade500,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color:
                                              (state.selectedInstitution !=
                                                      null &&
                                                  state
                                                      .selectedInstitution!
                                                      .isNotEmpty)
                                              ? AppColors.blueGradientEnd
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: AppColors.blueGradientEnd,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: constraints.maxWidth,
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final String option = options
                                                .elementAt(index);
                                            return ListTile(
                                              title: Text(
                                                option,
                                                style: AppTextStyles.regular14,
                                              ),
                                              onTap: () => onSelected(option),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Field 5: Kata Sandi
                      _buildTextField(
                        label: 'Kata Sandi',
                        isFilled: state.password.isNotEmpty,
                        obscureText: !state.isPasswordVisible,
                        onChanged: notifier.setPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: notifier.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Field 6: Ulangi Kata Sandi
                      _buildTextField(
                        label: 'Ulangi Kata Sandi',
                        isFilled: state.confirmPassword.isNotEmpty,
                        obscureText: !state.isConfirmPasswordVisible,
                        onChanged: notifier.setConfirmPassword,
                        isError: !state.isPasswordMatch,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: notifier.toggleConfirmPasswordVisibility,
                        ),
                      ),

                      // Peringatan jika kata sandi belum sama
                      if (!state.isPasswordMatch)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kata sandi belum sama',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 28),

                      // Tombol 'Daftar'
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isFormValid
                                ? AppColors.blueGradientEnd
                                : const Color(0xFFC4C4C4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          onPressed: state.isFormValid && !state.isLoading
                              ? () async {
                                  // Submit register
                                  await notifier.submitRegister();
                                  
                                  // Check state setelah submit
                                  if (context.mounted) {
                                    // Jika sukses (tidak ada error), redirect ke home
                                    if (state.errorMessage == null || state.errorMessage!.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Registrasi berhasil! Selamat datang.'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        if (context.mounted) {
                                          context.go('/home');
                                        }
                                      });
                                    } else {
                                      // Error sudah di-handle di state
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(state.errorMessage!),
                                          backgroundColor: Colors.red.shade700,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Daftar dengan Google
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          onPressed: () {
                            // Aksi Register Google
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Daftar dengan akun Google',
                                style: AppTextStyles.regular14.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SvgPicture.asset(
                                'assets/icons/google.svg',
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField Builder untuk kemudahan penambahan kolom baru
  Widget _buildTextField({
    required String label,
    required bool isFilled,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    bool isError = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isError
              ? Colors.red
              : (isFilled ? AppColors.blueGradientEnd : Colors.grey.shade500),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isError
                ? Colors.red
                : (isFilled ? AppColors.blueGradientEnd : Colors.grey.shade300),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isError ? Colors.red : AppColors.blueGradientEnd,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

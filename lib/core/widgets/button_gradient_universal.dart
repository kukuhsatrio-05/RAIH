// import 'package:flutter/material.dart';
// import 'package:raih/core/theme/app_colors.dart';
// import 'package:raih/core/theme/app_text_styles.dart';

// enum ButtonVariant {
//   primary,
//   secondary,
//   disabled,
//   outlined,
//   gradient,
//   gradientOutlined,
// }

// class ButtonGradient extends StatelessWidget {
//   final String? text;
//   final Widget? child;
//   final VoidCallback? onPressed;
//   final ButtonVariant variant;
//   final double width;
//   final double height;
//   final double borderRadius;

//   const ButtonGradient({
//     super.key,
//     this.text,
//     this.child,
//     required this.variant,
//     this.onPressed,
//     this.width = 344,
//     this.height = 60,
//     this.borderRadius = 16,
//   }) : assert(text != null || child != null, 'Berikan text atau child');

//   Color _backgroundColor() {
//     switch (variant) {
//       case ButtonVariant.primary:
//         return AppColors.blueNormal;
//       case ButtonVariant.secondary:
//         return AppColors.blueNormalActive;
//       case ButtonVariant.disabled:
//         return AppColors.blackLightActive;
//       case ButtonVariant.outlined:
//       case ButtonVariant.gradient:
//       case ButtonVariant.gradientOutlined:
//         return Colors.transparent;
//     }
//   }

//   BorderSide _borderSide() {
//     switch (variant) {
//       case ButtonVariant.outlined:
//         return BorderSide(color: AppColors.blueNormal, width: 2);
//       default:
//         return BorderSide.none;
//     }
//   }

//   Widget _buildButtonContent() {
//     // 1. Jika ada custom child (misal: Row dengan teks + Icon panah)
//     if (child != null) {
//       if (variant == ButtonVariant.gradientOutlined) {
//         return ShaderMask(
//           shaderCallback: (bounds) =>
//               AppColors.blueGradient.createShader(Offset.zero & bounds.size),
//           child: child,
//         );
//       }
//       return child!;
//     }

//     // 2. Default Text Widget
//     final String contentText = text!;

//     if (variant == ButtonVariant.gradientOutlined) {
//       return ShaderMask(
//         shaderCallback: (bounds) =>
//             AppColors.blueGradient.createShader(Offset.zero & bounds.size),
//         child: Text(
//           contentText,
//           textAlign: TextAlign.center,
//           style: AppTextStyles.bold16.copyWith(
//             color: Colors.white, // Diproteksi oleh ShaderMask
//           ),
//         ),
//       );
//     }

//     return Text(
//       contentText,
//       textAlign: TextAlign.center,
//       style: AppTextStyles.bold16.copyWith(
//         color: variant == ButtonVariant.outlined
//             ? AppColors.blueNormal
//             : Colors.white,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDisabled = variant == ButtonVariant.disabled;

//     // A. Handling Variant: Gradient Outlined
//     if (variant == ButtonVariant.gradientOutlined) {
//       return Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           gradient: AppColors.blueGradient,
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         padding: const EdgeInsets.all(2.0), // Ketebalan border
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(borderRadius - 2),
//           ),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(borderRadius - 2),
//               ),
//             ),
//             onPressed: isDisabled ? null : onPressed,
//             child: _buildButtonContent(),
//           ),
//         ),
//       );
//     }

//     // B. Handling Variant: Gradient Full
//     if (variant == ButtonVariant.gradient) {
//       return SizedBox(
//         width: width,
//         height: height,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             padding: EdgeInsets.zero,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(borderRadius),
//             ),
//           ),
//           onPressed: isDisabled ? null : onPressed,
//           child: Ink(
//             decoration: BoxDecoration(
//               gradient: AppColors.blueGradient,
//               borderRadius: BorderRadius.circular(borderRadius),
//             ),
//             child: Container(
//               alignment: Alignment.center,
//               child: _buildButtonContent(),
//             ),
//           ),
//         ),
//       );
//     }

//     // C. Handling Standard Variants (Primary, Secondary, Disabled, Outlined)
//     return SizedBox(
//       width: width,
//       height: height,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _backgroundColor(),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius),
//             side: _borderSide(),
//           ),
//           elevation: 0,
//         ),
//         onPressed: isDisabled ? null : onPressed,
//         child: _buildButtonContent(),
//       ),
//     );
//   }
// }

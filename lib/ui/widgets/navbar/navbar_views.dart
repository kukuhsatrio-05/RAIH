// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:raih/model/navbar_item_models.dart';
// import 'package:raih/ui/features/providers/view_models/navbar_providers.dart';
// import 'package:raih/core/constants/const.dart';

// class CustomBottomNavbar extends ConsumerWidget {
//   const CustomBottomNavbar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedIndex = ref.watch(navigationProvider);

//     final menus = <NavItemModel>[
//       const NavItemModel(
//         title: "Beranda",
//         icon: Icons.home_outlined,
//         route: "/",
//       ),

//       const NavItemModel(
//         title: "Mading",
//         icon: Icons.newspaper_outlined,
//         route: "/mading",
//       ),

//       const NavItemModel(
//         title: "Unggah",
//         icon: Icons.add_circle_outline,
//         route: "/upload",
//       ),

//       const NavItemModel(
//         title: "Materi",
//         icon: Icons.menu_book_outlined,
//         route: "/materi",
//       ),

//       const NavItemModel(
//         title: "Profil",
//         icon: Icons.person_outline,
//         route: "/profile",
//       ),
//     ];

//     return Container(
//       height: 78,
//       decoration: const BoxDecoration(
//         color: AppColors.whiteNormal,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 12,
//             color: AppColors.blackNormal,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(menus.length, (index) {
//           final item = menus[index];

//           final selected = selectedIndex == index;

//           return Expanded(
//             child: InkWell(
//               onTap: () {
//                 ref.read(navigationProvider.notifier).changeIndex(index);

//                 context.go(item.route);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(item.icon, color: selected ? Colors.blue : Colors.grey),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.title,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: selected ? Colors.blue : Colors.grey,
//                       fontWeight: selected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

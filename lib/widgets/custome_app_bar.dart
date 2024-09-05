import 'package:flutter/material.dart';
import 'package:meal_app/widgets/profile-icon.dart';
import 'cart_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int cartItemCount;
  final VoidCallback onCartPressed; // Callback for cart icon press

  const CustomAppBar({
    super.key,
    required this.cartItemCount,
    required this.onCartPressed, // Accept the callback
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.person),
        //   onPressed: () {
        //     // Handle user icon press
        //   },
        // ),
        ProfileIcon(),
        CartIcon(
          itemCount: cartItemCount,
          onPressed: onCartPressed, // Use the callback here
        ),
      ],
    );
  }
}

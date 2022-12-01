import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  const NavbarItem(
      {super.key,
      required this.label,
      required this.icon,
      required this.onItemPressed,
      required this.isSelected});

  final String label;
  final IconData icon;
  final Function() onItemPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: isSelected
            ? const Color.fromARGB(255, 43, 28, 161)
            : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListTile(
        onTap: onItemPressed,
        selected: true,
        hoverColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 26),
              Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.lightBlue.shade200 : Colors.white,
              ),
              const SizedBox(width: 25),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.lightBlue.shade200 : Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

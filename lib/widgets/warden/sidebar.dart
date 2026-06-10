import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/widgets/logout_helper.dart';

class Sidebar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const Sidebar({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color.fromARGB(255, 6, 24, 39),
      child: Column(
        // ensure sidebar content starts flush at the top so AppBar and Sidebar align
        children: [
          // small top padding inside tiles keeps content from colliding with status/app bar
          const SizedBox(height: 50),

          sidebarTile(
            context,
            Icons.people,
            "Students",
            onTap: () => onSelect("students"),
            isSelected: selected == "students",
          ),
          sidebarTile(
            context,
            Icons.check_circle,
            "Attendance",
            onTap: () => onSelect("attendance"),
            isSelected: selected == "attendance",
          ),
          sidebarTile(
            context,
            Icons.event_busy,
            "Leave Requests",
            onTap: () => onSelect("leave"),
            isSelected: selected == "leave",
          ),
          sidebarTile(
            context,
            Icons.keyboard_return,
            "Returns",
            onTap: () => onSelect("returns"),
            isSelected: selected == "returns",
          ),
           
          sidebarTile(
            context,
            Icons.logout,
            "Logout",
            onTap: () => LogoutHelper.logout(context),
          ),
        ],
      ),
    );
  }

  Widget sidebarTile(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isSelected ? Colors.amber : Colors.white),
        title: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.amber : Colors.white),
        ),
        tileColor: isSelected
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

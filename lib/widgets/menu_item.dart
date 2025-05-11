import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget page;

  MenuItem(this.title, this.icon, this.page);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          color: Colors.white.withOpacity(0.9),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 30, color: Colors.teal),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

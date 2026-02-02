
import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/pages/home_page.dart';

import '../../features/jobs/pages/jobs_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          // Header élégant
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Icon(
                        Icons.work_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'JobBoard',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    'Find your dream job',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Menu principal
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home_rounded,
                    color: isDark ? Colors.white : Theme.of(context).primaryColor,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context, MaterialPageRoute(builder: (_) => const HomePage()),);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.work_rounded,
                    color: isDark ? Colors.white : Theme.of(context).primaryColor,
                  ),
                  title: const Text('Jobs'),
                  onTap: () {
                    Navigator.pop(context, MaterialPageRoute( builder: (_) => const JobsPage()),);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.bookmark_rounded,
                    color: isDark ? Colors.white : Theme.of(context).primaryColor,
                  ),
                  title: const Text('Bookmarked'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Naviguer vers Bookmarked
                  },
                ),
              ],
            ),
          ),

          // Section Login/Sign Up en bas
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Naviguer vers Login
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Login'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: isDark ? Colors.white : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Naviguer vers Sign Up
                    },
                    icon: const Icon(Icons.person_add_rounded),
                    label: const Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

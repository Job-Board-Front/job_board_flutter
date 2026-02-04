import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/constants/app_colors.dart';
import 'package:job_board_flutter/features/bookmarks/pages/bookmarks_page.dart';
import 'package:job_board_flutter/core/guards/role_guard.dart';
import 'package:job_board_flutter/features/jobs/pages/home_page.dart';
import 'package:job_board_flutter/features/jobs/pages/jobs_page.dart';

import '../../features/auth/bloc/auth_cubit.dart';
import '../../features/auth/bloc/auth_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  String _getCurrentPageName(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments != null) {
      return route.settings.arguments as String;
    }

    // Vérifier le type de widget actuel dans la pile
    final navigator = Navigator.of(context);
    final currentRoute = navigator.widget;

    // Utiliser le type de page pour déterminer la page actuelle
    return 'home'; // valeur par défaut
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget? currentWidget;
    context.visitAncestorElements((element) {
      if (element.widget is HomePage) {
        currentWidget = element.widget;
        return false;
      }
      if (element.widget is JobsPage) {
        currentWidget = element.widget;
        return false;
      }
      if (element.widget is BookmarksPage) {
        currentWidget = element.widget;
        return false;
      }
      return true;
    });

    final isHomePage = currentWidget is HomePage;
    final isJobsPage = currentWidget is JobsPage;
    final isBookmarksPage = currentWidget is BookmarksPage;

    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = (state is AuthSuccess) ? state.user : null;
          final isLoggedIn = user != null;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.slate900 : Colors.white,
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
                    if (isLoggedIn) ...[
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          user!.displayName != null &&
                                  user.displayName!.isNotEmpty
                              ? user.displayName![0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.displayName ?? 'User',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF2196F3), Color(0xFF9C27B0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Icon(
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
                  ],
                ),
              ),


              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home_rounded,
                        color: isHomePage
                            ? (isDark? Colors.white : Theme.of(context).primaryColor)
                            : (isDark ? Colors.white : Colors.grey[700]),
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                          fontWeight: isHomePage ? FontWeight.bold : FontWeight.normal,
                          color: isHomePage ? (isDark? Colors.white : Theme.of(context).primaryColor) : null,
                        ),
                      ),
                      selected: isHomePage,
                      selectedTileColor: isDark
                          ? Colors.grey.withOpacity(0.2)
                          : Theme.of(context).primaryColor.withOpacity(0.1),

                      onTap: isHomePage ? null : () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.work_rounded,
                        color: isJobsPage
                            ? (isDark?Colors.white:Theme.of(context).primaryColor)
                            : (isDark ? Colors.white : Colors.grey[700]),
                      ),
                      title: Text(
                        'Jobs',
                        style: TextStyle(
                          fontWeight: isJobsPage ? FontWeight.bold : FontWeight.normal,
                          color: isJobsPage ? (isDark? Colors.white : Theme.of(context).primaryColor) : null,
                        ),
                      ),
                      selected: isJobsPage,
                      selectedTileColor: isDark
                          ? Colors.grey.withOpacity(0.2)
                          : Theme.of(context).primaryColor.withOpacity(0.1),

                      onTap: isJobsPage ? null : () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const JobsPage()),
                        );
                      },
                    ),
                    if (isLoggedIn)
                      ListTile(
                        leading: Icon(
                          Icons.bookmark_rounded,
                          color: isBookmarksPage
                              ? (isDark?Colors.white:Theme.of(context).primaryColor)
                              : (isDark ? Colors.white : Colors.grey[700]),
                        ),
                        title: Text(
                          'Bookmarks',
                          style: TextStyle(
                            fontWeight: isBookmarksPage ? FontWeight.bold : FontWeight.normal,
                            color: isBookmarksPage ? (isDark? Colors.white : Theme.of(context).primaryColor)  : null,
                          ),
                        ),
                        selected: isBookmarksPage,
                        selectedTileColor: isDark
                            ? Colors.grey.withOpacity(0.2)
                            : Theme.of(context).primaryColor.withOpacity(0.1),

                        onTap: isBookmarksPage ? null : () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookmarksPage(),
                            ),
                          );
                        },
                      ),
                    RoleGuard(
                      allowedRoles: ['admin'],
                      child: ListTile(
                        leading: Icon(
                          Icons.add_circle_outline_rounded,
                          color: isDark ? Colors.white : Colors.grey[700],
                        ),
                        title: const Text('Create Job'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/job-create');
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: isDark ? Colors.white : Colors.grey[300],
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: isLoggedIn
                    ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/login');
                              },
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Login'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
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
                                Navigator.pushNamed(context, '/register');
                              },
                              icon: const Icon(Icons.person_add_rounded),
                              label: const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

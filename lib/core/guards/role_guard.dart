import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_state.dart';

/// widget that conditionaly shows content based on user roles
class RoleGuard extends StatelessWidget {
  final List<String> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final user = state.user;
          final hasRole = allowedRoles.any((role) => user.hasRole(role));
          
          if (hasRole) {
            return child;
          }
        }
        
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

/// guard for admin only
Widget adminOnly({
  required Widget child,
  Widget? fallback,
}) {
  return RoleGuard(
    allowedRoles: ['admin'],
    child: child,
    fallback: fallback,
  );
}

class CurrentUser {
  final String uid;
  final String? email;
  final String? displayName;
  final List<String> roles;

  CurrentUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.roles,
  });

  bool get isAdmin => roles.contains('admin');
  bool hasRole(String role) => roles.contains(role);
}

enum UserRole { coach, client }

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.role,
    required this.displayName,
  });

  final String userId;
  final UserRole role;
  final String displayName;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['user_id'] as String,
        role: UserRole.values.byName((json['role'] as String).toLowerCase()),
        displayName: json['display_name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'role': role.name.toUpperCase(),
        'display_name': displayName,
      };
}

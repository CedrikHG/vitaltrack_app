class User {
  final String id;
  final String name;
  final String email;
  final DateTime? birthDate;
  final String? gender;
  final double? height;
  final double? weight;
  final bool notificationsEnabled;
  final bool termsAccepted;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
    this.notificationsEnabled = true,
    this.termsAccepted = false,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    bool? notificationsEnabled,
    bool? termsAccepted,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

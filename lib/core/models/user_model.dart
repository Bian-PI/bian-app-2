class User {
  final int? id;
  final String name;
  final String email;
  final String? document;
  final String? phone;
  final String? role;
  final bool isActiveSession;

  User({
    this.id,
    required this.name,
    required this.email,
    this.document,
    this.phone,
    this.role,
    this.isActiveSession = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'Usuario',
      email: json['email'] ?? '',
      document: json['document'],
      phone: json['phone'],
      role: json['role'] ?? 'user',
      isActiveSession: json['isActiveSession'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      if (document != null) 'document': document,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      'isActiveSession': isActiveSession,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? document,
    String? phone,
    String? role,
    bool? isActiveSession,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      document: document ?? this.document,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActiveSession: isActiveSession ?? this.isActiveSession,
    );
  }
}
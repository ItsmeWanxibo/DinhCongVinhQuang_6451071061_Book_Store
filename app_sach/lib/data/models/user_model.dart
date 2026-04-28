class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String avatar;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.avatar = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    fullName: map['fullName'] ?? '',
    email: map['email'] ?? '',
    phone: map['phone'] ?? '',
    avatar: map['avatar'] ?? '',
    createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'createdAt': createdAt,
  };

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? avatar,
  }) =>
      UserModel(
        uid: uid,
        fullName: fullName ?? this.fullName,
        email: email,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt,
      );
}
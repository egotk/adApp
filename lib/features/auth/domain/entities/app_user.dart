class AppUser {
  final String name;
  final String phoneNumber;

  AppUser({required this.name, required this.phoneNumber});

  // AppUser -> json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  // json -> AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

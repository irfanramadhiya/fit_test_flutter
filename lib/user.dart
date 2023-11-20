class UserApp {
  final String uid;
  final String name;
  final String email;
  final bool emailVerifivationStatus;

  UserApp(
      {required this.uid,
      required this.name,
      required this.email,
      required this.emailVerifivationStatus});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'email_verified': emailVerifivationStatus
      };

  static UserApp fromJson(Map<String, dynamic> json) => UserApp(
      uid: json['uid'],
      name: json["name"],
      email: json['email'],
      emailVerifivationStatus: json['email_verified']);
}

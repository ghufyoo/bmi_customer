class Users {
  final String nickname;
  final String email;
  final String phone;
  
  Users({
    required this.nickname,
    required this.email,
    required this.phone,

  });

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'email': email,
        'phonenumber': phone,
  
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        nickname: json['nickname'],
        email: json['email'],
        phone: json['phonenumber'],
   
      );
}

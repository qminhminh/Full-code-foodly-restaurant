import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
    final String email;
    final String password;

    LoginRequest({
        required this.email,
        required this.password,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}

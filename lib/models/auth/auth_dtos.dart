class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class SignupDto {
  final String email;
  final String password;

  SignupDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;
  final String message;
  final int statusCode;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.message,
    this.statusCode = 200,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user'] as Map<String, dynamic>,
      message: json['message'],
      statusCode: json['statusCode'] ?? 200,
    );
  }
}

class ErrorResponse {
  final String message;
  final int statusCode;

  ErrorResponse({
    required this.message,
    required this.statusCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

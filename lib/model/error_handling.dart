class ErrorHandling {
  String message;

  ErrorHandling({this.message});

  factory ErrorHandling.fromJson(Map<String, dynamic> json) {
    return ErrorHandling(
      message: json['message']
    );
  }
}

class SerializerHandling {
  List email;
  List phone;
  List password;

  SerializerHandling({this.email, this.phone, this.password});

  factory SerializerHandling.fromJson(Map<String, dynamic> json) {
    return SerializerHandling(
      email: json['email'],
      phone: json['phone'],
      password: json['password']
    );
  }
}
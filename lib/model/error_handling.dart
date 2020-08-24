class ErrorHandling {
  String message;

  ErrorHandling({this.message});

  factory ErrorHandling.fromJson(Map<String, dynamic> json) {
    return ErrorHandling(
      message: json['message']
    );
  }
}
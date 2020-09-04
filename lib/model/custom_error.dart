class CustomError implements Exception {
  String failedLogin() {
    return 'username or password invalid';
  }

  String serverMaintenance() {
    return 'server under maintenance';
  }
}
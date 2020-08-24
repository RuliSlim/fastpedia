// validation username and password
bool validatePassword({String password}) {
  RegExp pattern = RegExp(r"^(?:(?=.*?[A-Z])(?:(?=.*?[0-9])(?=.*?[-!@#$%^&*()_[\]{},.<>+=])|(?=.*?[a-z])(?:(?=.*?[0-9])|(?=.*?[-!@#$%^&*()_[\]{},.<>+=])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%^&*()_[\]{},.<>+=]))[A-Za-z0-9!@#$%^&*()_[\]{},.<>+=-]{8,20}$");
  return !pattern.hasMatch(password);
}

bool validateEmail({String email}) {
  RegExp pattern = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
  return !pattern.hasMatch(email);
}

bool validateNIK({String nik}) {
  RegExp pattern = RegExp(r"^[0-9]{16,22}$");
  return !pattern.hasMatch(nik);
}

bool validatePhone({String phone}) {
  RegExp pattern = RegExp(r"^0[1-9]{1}[0-9]{10,14}$");
  return !pattern.hasMatch(phone);
}
class RegexValidation {
  static bool validateEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}

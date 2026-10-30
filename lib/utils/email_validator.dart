
class EmailValidator {
  static bool isValid(String email) {
    final pattern = RegExp(
      r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
    );

    return pattern.hasMatch(email.trim());
  }

  static List<String> parseEmails(String input) {
    final emails = input
        .split(RegExp(r'[,;\n]+'))
        .map((email) => email.trim().toLowerCase())
        .where((email) => email.isNotEmpty)
        .toSet()
        .toList();

    return emails;
  }
}

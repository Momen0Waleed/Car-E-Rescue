class AppValidators {

  static String? validateEmptyField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field is Required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // 2. Password Validation (8+ chars, 1 Uppercase, 1 Number, 1 Special Char)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_+-]'));

    if (!hasUppercase) return 'Password needs at least one capital letter';
    if (!hasDigits) return 'Password needs at least one number';
    if (!hasSpecialChar) return 'Password needs at least one special character';

    return null;
  }

  static String? validateEgyptianPhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';

    final phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid Egyptian phone number (e.g., 01*********)';
    }
    return null;
  }
}
String? validateName(String? value) {
  print(2);
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }

  final name = value.trim();

  if (name.length < 3) {
    return 'Name must be at least 3 characters';
  }

  if (!RegExp(r'^[A-Za-z\u0600-\u06FF]').hasMatch(name)) {
    return 'Name must start with a letter';
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  final email = value.trim();

  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Please enter a valid email';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  if (!passwordRegex.hasMatch(value)) {
    return 'Password must contain uppercase, lowercase, number and special character';
  }

  return null;
}

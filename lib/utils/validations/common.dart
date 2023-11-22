String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  // Use a regular expression for basic email format validation
  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
    return 'Invalid email format';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  // Password should be at least 8 characters long and include letters and numbers
  if (value.length < 8 ||
      !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value)) {
    return 'Password must be at least 8 characters long and include letters and numbers';
  }

  return null;
}


mixin Validator {
  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email is required';
    } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
      return 'enter a valid email';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password is required';
    } else if (value.length < 6) {
      return 'password must be at least 6 characters';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'confirm password is required';
    } else if (value != password) {
      return 'confirm password does not match';
    }
    return null;
  }

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'name is required';
    }else if(value.contains("0123456789")){
      return 'enter a valid name';
    }
    return null;
  }
}
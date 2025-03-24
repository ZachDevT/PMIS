class TValidator {
// validate plain texts

  static String? validatePlainText(String? field, String? value) {
    if (value == null || value.isEmpty) {
      return '$field est requis';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email est requis.';
    }

// Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Adresse e-mail invalide.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis.';
    }
// Check for minimum password length
    if (value.length < 6) {
      return 'Le mot de passe doit comporter au moins 6 caractères';
    }
    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule';
    }

// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'le mot de passe doit contenir au moins un chiffre.';
    }
// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Le mot de passe doit contenir au moins un caractère spécial,';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro de téléphone est requis.';
    }
// Regular expression for phone number validation (assuming a 10-digit US phone number format)

    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Format de numéro de téléphone invalide (10 chiffres requis).';
    }
    return null;
  }
}

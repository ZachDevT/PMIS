class TfirebaseException implements Exception {
  final String code;
  TfirebaseException(this.code);

  String get message {
    switch (code) {
      // FirebaseAuth exceptions (User-related)
      case 'user-not-found':
        return "Utilisateur non trouvé. Veuillez vérifier vos identifiants.";
      case 'wrong-password':
        return "Mot de passe incorrect. Veuillez réessayer.";
      case 'email-already-in-use':
        return "L'adresse e-mail est déjà utilisée. Veuillez en choisir une autre.";
      case 'operation-not-allowed':
        return "Opération non autorisée. Veuillez contacter le support.";
      case 'weak-password':
        return "Le mot de passe est trop faible. Veuillez en choisir un plus fort.";
      case 'user-disabled':
        return "Ce compte utilisateur a été désactivé. Contactez le support.";
      case 'invalid-verification-code':
        return "Code de vérification invalide. Veuillez vérifier et réessayer.";
      case 'invalid-verification-id':
        return "ID de vérification invalide. Veuillez vérifier et réessayer.";
      case 'phone-number-already-in-use':
        return "Le numéro de téléphone est déjà utilisé. Veuillez en choisir un autre.";
      case 'credential-already-in-use':
        return "Les informations d'identification sont déjà utilisées par un autre compte.";
      case 'missing-phone-number':
        return "Le numéro de téléphone est requis pour l'opération.";
      case 'account-exists-with-different-credential':
        return "Un compte existe déjà avec la même adresse e-mail mais des informations d'identification différentes.";
      case 'requires-recent-login':
        return "L'action nécessite une connexion récente. Veuillez vous connecter à nouveau.";
      case 'user-mismatch':
        return "Incohérence utilisateur. Les informations d'identification fournies ne correspondent pas à l'utilisateur existant.";
      case 'invalid-user-token':
        return "Token utilisateur invalide. Veuillez vous connecter à nouveau.";
      case 'user-token-expired':
        return "Le token utilisateur a expiré. Veuillez vous connecter à nouveau.";
      case 'web-storage-unsupported':
        return "Le stockage web n'est pas pris en charge par le navigateur actuel.";
      case 'cancelled':
        return "L'opération a été annulée.";
      case 'unknown':
        return "Une erreur inconnue s'est produite.";
      case 'invalid-argument':
        return "Argument invalide fourni.";
      case 'deadline-exceeded':
        return "L'opération a expiré.";
      case 'not-found':
        return "Le document ou la ressource demandé(e) n'a pas été trouvé(e).";
      case 'already-exists':
        return "Le document ou la ressource existe déjà.";
      case 'permission-denied':
        return "Autorisation refusée. Vérifiez vos règles de sécurité.";
      case 'unauthenticated':
        return "L'utilisateur n'est pas authentifié. Connectez-vous pour effectuer cette opération.";

// Exceptions de la base de données en temps réel
      case 'datastale':
        return "Les données sont obsolètes et peuvent ne plus être précises.";
      case 'overridden-by-set':
        return "La transaction a été remplacée par un ensemble ultérieur.";
      case 'transaction-aborted':
        return "La transaction a été annulée.";
      case 'network-error':
        return "Une erreur réseau s'est produite.";

// Exceptions des fonctions Cloud
      case 'resource-exhausted':
        return "Ressource épuisée. Pensez à optimiser votre fonction.";

// Ajoutez plus de cas pour d'autres exceptions Firebase au besoin

      default:
        return "Une erreur inattendue s'est produite. Veuillez réessayer.";
    }
  }
}

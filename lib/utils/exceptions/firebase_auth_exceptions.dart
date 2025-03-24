class TFirebaseAuthExceptions implements Exception {
  TFirebaseAuthExceptions(this.code);
  String code;

  String get message {
    switch (code) {
      case 'invalid-email':
        return "Adresse e-mail invalide.";
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
      case 'network-request-failed':
        return "Échec de la requête réseau. Veuillez vérifier votre connexion internet.";
      case 'too-many-requests':
        return "Trop de requêtes. Veuillez réessayer ultérieurement.";
      case 'app-not-authorized':
        return "L'application n'est pas autorisée à utiliser l'authentification Firebase.";
      case 'user-disabled':
        return "Ce compte utilisateur a été désactivé.";
      case 'invalid-verification-code':
        return "Code de vérification invalide. Veuillez vérifier et réessayer.";
      case 'invalid-verification-id':
        return "ID de vérification invalide. Veuillez vérifier et réessayer.";
      case 'phone-number-already-in-use':
        return "Le numéro de téléphone est déjà utilisé. Veuillez en choisir un autre.";
      case 'quota-exceeded':
        return "Quota Firebase dépassé. Veuillez contacter le support.";
      case 'provider-already-linked':
        return "Le fournisseur est déjà lié à un autre compte.";
      case 'credential-already-in-use':
        return "Les informations d'identification sont déjà utilisées par un autre compte.";
      case 'missing-phone-number':
        return "Le numéro de téléphone est requis pour l'opération.";
      case 'popup-closed-by-user':
        return "La fenêtre contextuelle a été fermée par l'utilisateur. Veuillez réessayer.";
      case 'account-exists-with-different-credential':
        return "Un compte existe déjà avec la même adresse e-mail mais des informations d'identification différentes.";
      case 'invalid-api-key':
        return "Clé API invalide. Veuillez vérifier les paramètres de votre projet Firebase.";
      case 'web-storage-unsupported':
        return "Le stockage web n'est pas pris en charge par le navigateur actuel.";
      case 'app-not-registered':
        return "L'application n'est pas enregistrée avec Firebase. Vérifiez votre configuration.";
      case 'missing-app-credential':
        return "Informations d'identification de l'application manquantes. Vérifiez les paramètres de votre projet Firebase.";
      case 'invalid-user-token':
        return "Token utilisateur invalide. Veuillez vous connecter à nouveau.";
      case 'invalid-continue-uri':
        return "URI de continuation invalide. Vérifiez la configuration de votre lien profond.";
      case 'unauthorized-domain':
        return "Domaine non autorisé. Ajoutez votre domaine à la liste des domaines autorisés dans Firebase.";
      case 'invalid-credential':
        return "Informations d'identification invalides. Veuillez vous connecter à nouveau.";
      case 'requires-recent-login':
        return "L'action nécessite une connexion récente. Veuillez vous connecter à nouveau.";
      case 'email-already-exists':
        return "L'adresse e-mail existe déjà. Veuillez en choisir une autre.";
      case 'invalid-tenant-id':
        return "ID de locataire invalide. Veuillez vérifier les paramètres de votre projet Firebase.";
      case 'user-mismatch':
        return "Incohérence utilisateur. Les informations d'identification fournies ne correspondent pas à l'utilisateur existant.";
      case 'operation-not-supported-in-this-environment':
        return "Opération non prise en charge dans cet environnement.";
      case 'invalid-message-payload':
        return "Charge de message invalide. Vérifiez le format de votre message FCM.";
      case 'invalid-recipient-email':
        return "Adresse e-mail du destinataire invalide. Veuillez vérifier et réessayer.";
      case 'user-token-expired':
        return "Le token utilisateur a expiré. Veuillez vous connecter à nouveau.";
      case 'invalid-action-code':
        return "Code d'action invalide. Veuillez vérifier votre e-mail pour un lien valide.";
      default:
        return "Une erreur inattendue s'est produite. Veuillez réessayer.";
    }
  }
}

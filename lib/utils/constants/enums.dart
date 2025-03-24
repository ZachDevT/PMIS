// enmums can't be declared inside a class;
enum Textsizes {
  small,
  medium,
  large,
}

enum OrderStatus {
  encours,
  shipped,
  delivered,
  cancelled,
}

enum Paymentmethods {
  payPal,
  visa,
  googlePay,
  applePay,
  masterCard,
  creditCard,
  razorPay,
  payTm,
  payStack
}
enum NotificationType {
  paymentUpdated,
  NewMessage,
  other,
  PaymentReceived

 
}

extension NotificationExtension on NotificationType {
  String get description {
    switch (this) {
     
      case NotificationType.paymentUpdated:
        return 'Mis à jour payment';
      case NotificationType.NewMessage:
        return 'Nouveau message ';
      case NotificationType.other:
        return 'Nouvelle notification';
      
      case NotificationType.PaymentReceived:
        return 'Payement reçu';
      
      default:
        return '';
    }
  }

  String toJson() => name;

  static NotificationType fromJson(String json) =>
      NotificationType.values.firstWhere((e) => e.name == json);
}

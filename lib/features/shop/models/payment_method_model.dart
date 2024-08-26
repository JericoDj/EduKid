import 'package:square_in_app_payments/models.dart'; // Import for CardDetails

class PaymentMethodModel {
  String name;
  String image;
  CardDetails? cardDetails; // Add this field

  PaymentMethodModel({required this.image, required this.name, this.cardDetails});

  static PaymentMethodModel empty() => PaymentMethodModel(image: '', name: '');
}

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_getway/stripe_payment/stripe_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment({
    required int amount,
    required String currency,
  }) async {
    try {
      String clientSecret = await _getPaymentIntentId(
        amount: (amount * 100).toString(),
        currency: currency,
      );
      await _initializePaymentSheet(clientSecret: clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> _initializePaymentSheet(
      {required String clientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Flutter Stripe Store',
      ),
    );
  }

  static Future<String> _getPaymentIntentId(
      {required String amount, required String currency}) async {
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${StripeKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }
}

import 'package:flutter/material.dart';
import 'package:payment_getway/stripe_payment/payment_manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FLUTTER STRIPE'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              PaymentManager.makePayment(amount: 100, currency: 'USD');
            },
            child: Text('pay 100 USD')),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutterpayments/payment/payment_cart.dart';
import 'package:http/http.dart' as http;

class CheckoutPayment {
  static const String _publicKey =
      'pk_test_000bc7f8-3697-4aa1-9520-114c277e26db';
  static const String _secretKey =
      'sk_test_1d2d8680-44d5-402a-97ea-98dee5770edf';

  static const Map<String, String> _tokenHeader = {
    'Content-Type': 'Application/json',
    'Authorization': _publicKey
  };
  static const Map<String, String> _paymentHeader = {
    'Content-Type': 'Application/json',
    'Authorization': _secretKey
  };
  static const _tokenUrl = 'https://api.sandbox.checkout.com/tokens';
  static const _paymentUrl = 'https://api.sandbox.checkout.com/payments';

  Future<String> _getToken(PaymentCard card) async {
    Map<String, String> body = {
      'type': 'card',
      'number': card.number,
      'expiry_month': card.expiry_month,
      'expiry_year': card.expiry_year
    };
    http.Response response = await http.post(_tokenUrl,
        headers: _tokenHeader, body: jsonEncode(body));
    switch (response.statusCode) {
      case 201:
        var data = jsonDecode(response.body);
        return data['token'];
        break;
      default:
        throw Exception('Card invalid');
        break;
    }
  }

  Future<String> makePayment(PaymentCard card, int amount) async {
    String token = await _getToken(card);
    print(token);
    Map<String, dynamic> body = {
      'source': {
        'type': 'token',
        'token': token
      },
      'amount': amount,
      'currency': 'usd'
    };
    http.Response response = await http.post(_paymentUrl,
        headers: _paymentHeader, body: jsonEncode(body));
    switch (response.statusCode) {
      case 201:
        var data = jsonDecode(response.body);
        return data['response_summary'];
        break;
      default:
        throw Exception('Payment failed');
        break;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutterpayments/payment/payment_cart.dart';

import 'check_out.dart';

class CreditCard extends StatefulWidget {


  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused, //true when you want to show cvv(back) view
              ),
              CreditCardForm(
                themeColor: Colors.red,
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                    isCvvFocused = data.isCvvFocused;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          int cvc = int.tryParse(cvvCode);
          int carNo = int.tryParse(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
          int exp_year = int.tryParse(expiryDate.substring(3,5));
          int exp_month = int.tryParse(expiryDate.substring(0,2));

          print("cvc num: ${cvc.toString()}");
          print("card num: ${carNo.toString()}");
          print("exp year: ${exp_year.toString()}");
          print("exp month: ${exp_month.toString()}");
          print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));

          PaymentCard card = PaymentCard(carNo.toString(), exp_month.toString(), exp_year.toString());
          CheckoutPayment  payment =CheckoutPayment();
          payment.makePayment(card, 1550);

        },
        tooltip: 'Submit',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

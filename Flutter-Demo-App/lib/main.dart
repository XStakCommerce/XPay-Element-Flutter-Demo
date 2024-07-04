import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xpay_element_flutter/xpay_element_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(
          title: "XPay Flutter Payment SDK",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isReady = false;
  late bool isPaymentInProgress = false;
  final XPayElementController controller = XPayElementController(
      publicKey:
          "your_account_public_api_key",
      hmacKey:
          "your_account_hmac_api_key",
      accountId: "your_account_id");
  XPayElementCustomStyle style = XPayElementCustomStyle.configureCustomStyle({
    "inputConfiguration": {
      "cardNumber": {
        "label": "Card Number",
        "placeholder": "Enter card number"
      },
      "expiry": {"label": "Expiry Date", "placeholder": "MM/YY"},
      "cvc": {"label": "CVC", "placeholder": "Enter cvc"}
    },
    "inputStyle": {
      "height": 40,
      "textColor": 0xff000000,
      "textSize": 16,
      "fontWeight": 400,
      "borderColor": 0xffe6e6e6,
      "borderRadius": 5,
      "borderWidth": 1
    },
    "inputLabelStyle": {
      "fontSize": 16,
      "fontWeight": 400,
      "textColor": 0xff000000
    },
    "onFucusInputStyle": {
      "textColor": 0xff000000,
      "textSize": 16,
      "fontWeight": 400,
      "borderColor": 0xffc8dbf9,
      "borderWidth": 1
    },
    "invalidStyle": {
      "borderColor": 0xffff0000,
      "borderWidth": 1,
      "textColor": 0xffff0000,
      "textSize": 14,
      "fontWeight": 400
    },
    "errorMessageStyle": {
      "textColor": 0xffff0000,
      "textSize": 14,
      "fontWeight": 400
    }
  });
  void handleConfirmPayment() async {
    const String customerEmail = "linkwithxstak@gmail.com";
    const String customerName = "John Doe";
    const String customerPhone = "1234567890";
    const String shippingAddress1 = "123 Main St";
    const String shippingCity = "Lahore";
    const String shippingCountry = "Pakistan";
    const String shippingProvince = "Punjab";
    const String shippingZip = "54000";
    final int randomDigits =
        Random().nextInt(900000) + 100000; // Ensure it is 6 digits
    final String orderReference = "order-$randomDigits";
    String body = jsonEncode({
      "amount": 1,
      "currency": "PKR",
      "payment_method_types": "card",
      "customer": {
        "email": customerEmail,
        "name": customerName,
        "phone": customerPhone,
      },
      "shipping": {
        "address1": shippingAddress1,
        "city": shippingCity,
        "country": shippingCountry,
        "province": shippingProvince,
        "zip": shippingZip,
      },
      "metadata": {
        "order_reference": orderReference,
      }
    });
    setState(() {
      isPaymentInProgress = true;
    });
    try {
      http.Response response = await http.post(
          Uri.parse(
              'http://localhost:4242/create-payment-intent'),
          headers: {'Content-Type': 'application/json'},
          body: body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var paymentResponse = await controller.confirmPayment(
            customerName: "Amir",
            clientSecret: result['clientSecret'],
            encryptionsKeys: result['encryptionKey']);
        var snackBar = SnackBar(
            content: Text(
                "Error : ${paymentResponse.error} Message : ${paymentResponse.message}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating payment: $e');
    }
    setState(() {
      isPaymentInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Use minimum space that the children need
          children: [
            XPayElementWidget(
              style: style,
              controller: controller,
              onBinDiscount: (value) {
                var snackBar =
                    SnackBar(content: Text("Bin Discount : ${value}"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              onReady: (bool result) {
                setState(() {
                  isReady = result;
                });
              },
            ),
            const SizedBox(
                height: 20), // Adds spacing between the form and buttons
            ElevatedButton(
              onPressed: () {
                if (!isPaymentInProgress && isReady) {
                  handleConfirmPayment();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isReady ? Colors.blue : Colors.grey,
                minimumSize: const Size(double.infinity,
                    50), // Set the button's width to full and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Border radius of 5
                ),
              ),
              child: isPaymentInProgress
                  ? const SizedBox(
                      width: 20, // Specific size for CircularProgressIndicator
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      "Pay PKR 5.0",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            const SizedBox(height: 10), // Adds spacing between the two buttons
            ElevatedButton(
              onPressed: () {
                if (!isPaymentInProgress) {
                  controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity,
                    50), // Set the button's width to full and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Border radius of 5
                ),
              ),
              child: const Text(
                "Clear",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
